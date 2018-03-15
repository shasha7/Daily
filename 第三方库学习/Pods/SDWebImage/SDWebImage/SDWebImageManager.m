/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageManager.h"
#import "NSImage+WebCache.h"
#import <objc/message.h>

@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic, nullable) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic, nullable) NSOperation *cacheOperation;

@end

@interface SDWebImageManager ()

@property (strong, nonatomic, readwrite, nonnull) SDImageCache *imageCache;
@property (strong, nonatomic, readwrite, nonnull) SDWebImageDownloader *imageDownloader;
@property (strong, nonatomic, nonnull) NSMutableSet<NSURL *> *failedURLs;
@property (strong, nonatomic, nonnull) NSMutableArray<SDWebImageCombinedOperation *> *runningOperations;

@end

@implementation SDWebImageManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    SDImageCache *cache = [SDImageCache sharedImageCache];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    return [self initWithCache:cache downloader:downloader];
}

- (nonnull instancetype)initWithCache:(nonnull SDImageCache *)cache downloader:(nonnull SDWebImageDownloader *)downloader {
    if ((self = [super init])) {
        _imageCache = cache;
        _imageDownloader = downloader;
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url {
    if (!url) {
        return @"";
    }

    if (self.cacheKeyFilter) {
        return self.cacheKeyFilter(url);
    } else {
        return url.absoluteString;
    }
}

- (void)cachedImageExistsForURL:(nullable NSURL *)url
                     completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    BOOL isInMemoryCache = ([self.imageCache imageFromMemoryCacheForKey:key] != nil);
    
    if (isInMemoryCache) {
        // making sure we call the completion block on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(YES);
            }
        });
        return;
    }
    
    [self.imageCache diskImageExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // the completion block of checkDiskCacheForImageWithKey:completion: is always called on the main queue, no need to further dispatch
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (void)diskImageExistsForURL:(nullable NSURL *)url
                   completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    [self.imageCache diskImageExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // the completion block of checkDiskCacheForImageWithKey:completion: is always called on the main queue, no need to further dispatch
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (id <SDWebImageOperation>)loadImageWithURL:(nullable NSURL *)url
                                     options:(SDWebImageOptions)options
                                    progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                   completed:(nullable SDInternalCompletionBlock)completedBlock {
    // Invoking this method without a completedBlock is pointless
    NSAssert(completedBlock != nil, @"If you mean to prefetch the image, use -[SDWebImagePrefetcher prefetchURLs] instead");

    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, Xcode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    // 确定url是否被正确传入,如果传入参数的是NSString类型就会被转换为NSURL.如果转换失败,那么 url会被赋值为空,这个下载的操作就会出错.
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }

    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }

    // 这里仅仅是将实现了SDWebImageOperation协议的NSObject子类包装成一个看着像NSOperation其实并不是NSOperation的类,而这个类唯一与NSOperation的相同之处就是它们都可以响应cancel方法。
    __block SDWebImageCombinedOperation *operation = [SDWebImageCombinedOperation new];
    __weak SDWebImageCombinedOperation *weakOperation = operation;

    // 当前下载的图片地址，是否包含在以前失败NSMutableSet里面
    BOOL isFailedUrl = NO;
    if (url) {
        @synchronized (self.failedURLs) {
            isFailedUrl = [self.failedURLs containsObject:url];
        }
    }

    // 当传url是NSString的时候，转换而来的NSURL并不一定是真实有效的下载地址
    if (url.absoluteString.length == 0 || (!(options & SDWebImageRetryFailed) && isFailedUrl)) {
        [self callCompletionBlockForOperation:operation completion:completedBlock error:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil] url:url];
        /*
        实际上是在主线程中调用回调completedBlock
        dispatch_main_async_safe(^{
            if (operation && !operation.isCancelled && completedBlock) {
                completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], SDImageCacheTypeNone, YES, url);
            }
        });
         */
        return operation;
    }

    // 加到正在下载NSMutableArray数组中
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    
    // 再通过url获取对应的key,一般情况是url.absoluteString
    NSString *key = [self cacheKeyForURL:url];

    // 使用key在缓存中查找以前是否下载过相同的图片的NSOperation，并赋值给上面那个不正经的operation中正经的cacheOperation
    // 如果我们在缓存中查找到了对应的图片NSOperation, 那么我们直接调用completedBlock回调块结束这一次的图片下载操作.
    operation.cacheOperation = [self.imageCache queryCacheOperationForKey:key done:^(UIImage *cachedImage, NSData *cachedData, SDImageCacheType cacheType) {
        if (operation.isCancelled) {
            [self safelyRemoveOperationFromRunning:operation];
            return;
        }
        
        // 没有找到缓存或者使用SDWebImageRefreshCached缓存策略 且 没有实现imageManager:shouldDownloadImageForURL代理方法:或者实现了但是Return NO
        if ((!cachedImage || options & SDWebImageRefreshCached) && (![self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)] || [self.delegate imageManager:self shouldDownloadImageForURL:url])) {
            if (cachedImage && options & SDWebImageRefreshCached) {
                // If image was found in the cache but SDWebImageRefreshCached is provided, notify about the cached image
                // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
                [self callCompletionBlockForOperation:weakOperation completion:completedBlock image:cachedImage data:cachedData error:nil cacheType:cacheType finished:YES url:url];
            }
            
            // download if no image or requested to refresh anyway, and download allowed by delegate
            SDWebImageDownloaderOptions downloaderOptions = 0;
            if (options & SDWebImageLowPriority) downloaderOptions |= SDWebImageDownloaderLowPriority;
            if (options & SDWebImageProgressiveDownload) downloaderOptions |= SDWebImageDownloaderProgressiveDownload;
            if (options & SDWebImageRefreshCached) downloaderOptions |= SDWebImageDownloaderUseNSURLCache;
            if (options & SDWebImageContinueInBackground) downloaderOptions |= SDWebImageDownloaderContinueInBackground;
            if (options & SDWebImageHandleCookies) downloaderOptions |= SDWebImageDownloaderHandleCookies;
            if (options & SDWebImageAllowInvalidSSLCertificates) downloaderOptions |= SDWebImageDownloaderAllowInvalidSSLCertificates;
            if (options & SDWebImageHighPriority) downloaderOptions |= SDWebImageDownloaderHighPriority;
            if (options & SDWebImageScaleDownLargeImages) downloaderOptions |= SDWebImageDownloaderScaleDownLargeImages;
            
            if (cachedImage && options & SDWebImageRefreshCached) {
                // force progressive off if image already cached but forced refreshing
                downloaderOptions &= ~SDWebImageDownloaderProgressiveDownload;
                // ignore image read from NSURLCache if image if cached but force refreshing
                downloaderOptions |= SDWebImageDownloaderIgnoreCachedResponse;
            }
            
            SDWebImageDownloadToken *subOperationToken = [self.imageDownloader downloadImageWithURL:url options:downloaderOptions progress:progressBlock completed:^(UIImage *downloadedImage, NSData *downloadedData, NSError *error, BOOL finished) {
                __strong __typeof(weakOperation) strongOperation = weakOperation;
                if (!strongOperation || strongOperation.isCancelled) {
                    // Do nothing if the operation was cancelled
                    // See #699 for more details
                    // if we would call the completedBlock, there could be a race condition between this block and another completedBlock for the same object, so if this one is called second, we will overwrite the new data
                } else if (error) {
                    [self callCompletionBlockForOperation:strongOperation completion:completedBlock error:error url:url];
                    
                    if (   error.code != NSURLErrorNotConnectedToInternet
                        && error.code != NSURLErrorCancelled
                        && error.code != NSURLErrorTimedOut
                        && error.code != NSURLErrorInternationalRoamingOff
                        && error.code != NSURLErrorDataNotAllowed
                        && error.code != NSURLErrorCannotFindHost
                        && error.code != NSURLErrorCannotConnectToHost
                        && error.code != NSURLErrorNetworkConnectionLost) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs addObject:url];
                        }
                    }
                }
                else {
                    if ((options & SDWebImageRetryFailed)) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs removeObject:url];
                        }
                    }
                    
                    BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                    
                    if (options & SDWebImageRefreshCached && cachedImage && !downloadedImage) {
                        // Image refresh hit the NSURLCache cache, do not call the completion block
                    } else if (downloadedImage && (!downloadedImage.images || (options & SDWebImageTransformAnimatedImage)) && [self.delegate respondsToSelector:@selector(imageManager:transformDownloadedImage:withURL:)]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            UIImage *transformedImage = [self.delegate imageManager:self transformDownloadedImage:downloadedImage withURL:url];
                            
                            if (transformedImage && finished) {
                                BOOL imageWasTransformed = ![transformedImage isEqual:downloadedImage];
                                // pass nil if the image was transformed, so we can recalculate the data from the image
                                [self.imageCache storeImage:transformedImage imageData:(imageWasTransformed ? nil : downloadedData) forKey:key toDisk:cacheOnDisk completion:nil];
                            }
                            
                            [self callCompletionBlockForOperation:strongOperation completion:completedBlock image:transformedImage data:downloadedData error:nil cacheType:SDImageCacheTypeNone finished:finished url:url];
                        });
                    } else {
                        if (downloadedImage && finished) {
                            [self.imageCache storeImage:downloadedImage imageData:downloadedData forKey:key toDisk:cacheOnDisk completion:nil];
                        }
                        [self callCompletionBlockForOperation:strongOperation completion:completedBlock image:downloadedImage data:downloadedData error:nil cacheType:SDImageCacheTypeNone finished:finished url:url];
                    }
                }
                
                if (finished) {
                    [self safelyRemoveOperationFromRunning:strongOperation];
                }
            }];
            @synchronized(operation) {
                // Need same lock to ensure cancelBlock called because cancel method can be called in different queue
                operation.cancelBlock = ^{
                    [self.imageDownloader cancel:subOperationToken];
                    __strong __typeof(weakOperation) strongOperation = weakOperation;
                    [self safelyRemoveOperationFromRunning:strongOperation];
                };
            }
        } else if (cachedImage) {
            __strong __typeof(weakOperation) strongOperation = weakOperation;
            [self callCompletionBlockForOperation:strongOperation completion:completedBlock image:cachedImage data:cachedData error:nil cacheType:cacheType finished:YES url:url];
            [self safelyRemoveOperationFromRunning:operation];
        } else {
            // Image not in cache and download disallowed by delegate
            __strong __typeof(weakOperation) strongOperation = weakOperation;
            [self callCompletionBlockForOperation:strongOperation completion:completedBlock image:nil data:nil error:nil cacheType:SDImageCacheTypeNone finished:YES url:url];
            [self safelyRemoveOperationFromRunning:operation];
        }
    }];

    return operation;
}

- (void)saveImageToCache:(nullable UIImage *)image forURL:(nullable NSURL *)url {
    if (image && url) {
        NSString *key = [self cacheKeyForURL:url];
        [self.imageCache storeImage:image forKey:key toDisk:YES completion:nil];
    }
}

- (void)cancelAll {
    @synchronized (self.runningOperations) {
        NSArray<SDWebImageCombinedOperation *> *copiedOperations = [self.runningOperations copy];
        [copiedOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:copiedOperations];
    }
}

- (BOOL)isRunning {
    BOOL isRunning = NO;
    @synchronized (self.runningOperations) {
        isRunning = (self.runningOperations.count > 0);
    }
    return isRunning;
}

- (void)safelyRemoveOperationFromRunning:(nullable SDWebImageCombinedOperation*)operation {
    @synchronized (self.runningOperations) {
        if (operation) {
            [self.runningOperations removeObject:operation];
        }
    }
}

- (void)callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation*)operation
                             completion:(nullable SDInternalCompletionBlock)completionBlock
                                  error:(nullable NSError *)error
                                    url:(nullable NSURL *)url {
    [self callCompletionBlockForOperation:operation completion:completionBlock image:nil data:nil error:error cacheType:SDImageCacheTypeNone finished:YES url:url];
}

- (void)callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation*)operation
                             completion:(nullable SDInternalCompletionBlock)completionBlock
                                  image:(nullable UIImage *)image
                                   data:(nullable NSData *)data
                                  error:(nullable NSError *)error
                              cacheType:(SDImageCacheType)cacheType
                               finished:(BOOL)finished
                                    url:(nullable NSURL *)url {
    dispatch_main_async_safe(^{
        if (operation && !operation.isCancelled && completionBlock) {
            completionBlock(image, data, error, cacheType, finished, url);
        }
    });
}

@end


@implementation SDWebImageCombinedOperation

- (void)setCancelBlock:(nullable SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    @synchronized(self) {
        self.cancelled = YES;
        if (self.cacheOperation) {
            [self.cacheOperation cancel];
            self.cacheOperation = nil;
        }
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
    }
}

@end
