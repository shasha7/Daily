//
//  DBRequestManager.m
//  DBNetworking
//
//  Created by 建雄 王 on 15/6/18.
//  Copyright (c) 2015年 建雄 王. All rights reserved.
//

#import "DBRequestManager.h"
#import "AFNetworking.h"
#import "DBMacro.h"
#import "DBShareData.h"

//#import "JiaYuanEncrypt.h"
//#import "JiaYuanLocalData.h"
//#import "ChatDataController.h"

typedef NS_ENUM(NSUInteger, DBRequestType) {
    DBRequestTypeGET = 1,
    DBRequestTypePOST = 2,
    DBRequestTypeUPLOAD = 3,
    DBRequestTypeDOWNLOAD = 4,
};

typedef NS_ENUM(int, DBRequestErrors) {
    kDBRequestErrorTokenInvalid = -1025,
    kDBRequestErrorCancelled = -999,
};

static NSDictionary * FillParameters(NSDictionary *parameters, NSURL *url) {
    BOOL needFill = NO;
    if ([url.host containsString:@"douban.com"])
        needFill = YES;
    if ([url.host containsString:@"miuu.cn"])
        needFill = YES;
    if ([url.host containsString:@"DB1.me"])
        needFill = YES;
    if (!needFill)
        return parameters;
    
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionary];
    
    NSArray *parametersKeys = [parameters allKeys];
    for (id key in parametersKeys) {
        [newParameters setObject:[parameters objectForKey:key] forKey:key];
    }
    
    newParameters[@"lang"] = [DBShareData sharedShareData].deviceInfo.appLang;
    newParameters[@"clientid"] = @(kAppClientId);
    newParameters[@"channelid"] = @(kAppChannelId);
    newParameters[@"channel"] = @(kAppChannelId);
    newParameters[@"ver"] = [DBShareData sharedShareData].deviceInfo.appVer;
    newParameters[@"idfa"] = [DBShareData sharedShareData].idfa?:@"";
    
    return newParameters;
}

static NSString * const kDBRefreshTokenResult = @"com.jiayuan.refresh.token.result";
static NSString * const kDBTokenInvalid = @"com.jiayuan.token.invalid";

@interface DBHTTPSessionManager : AFHTTPSessionManager

@end

@implementation DBHTTPSessionManager

+ (instancetype)sharedManager {
    static DBHTTPSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DBHTTPSessionManager alloc] initWithBaseURL:nil];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    
    return _sharedManager;
}

- (void)dealloc {
    [self invalidateSessionCancelingTasks:YES];
}

@end

#pragma mark -

@interface DBHTTPResponseSessionManager : DBHTTPSessionManager

@end

@implementation DBHTTPResponseSessionManager

+ (instancetype)sharedManager {
    static DBHTTPResponseSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DBHTTPResponseSessionManager alloc] initWithBaseURL:nil];
        _sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedManager;
}

@end

#pragma mark -

@interface DBJSONRequestSessionManager : DBHTTPSessionManager

@end

@implementation DBJSONRequestSessionManager

+ (instancetype)sharedManager {
    static DBJSONRequestSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DBJSONRequestSessionManager alloc] initWithBaseURL:nil];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return _sharedManager;
}

@end

#pragma mark -

@interface DBRequestParametersManager : NSObject
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) void (^success)(id result);
@property (nonatomic, copy) void (^failure)(NSString *errorDesc);
@property (nonatomic, assign) DBRequestType requestType;
@property (nonatomic, copy) NSString *downloadDestinationPath;
@property (nonatomic, copy) void (^progress)(double fractionCompleted);
@property (nonatomic, copy) NSString *downloadMethod;
@property (nonatomic, copy) void (^constructingBody)(id formData);
@property (nonatomic, strong) DBRequestManager *requestManager;

- (instancetype)initWithURLString:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(NSString *errorDesc))failure
                      requestType:(DBRequestType)requestType
          downloadDestinationPath:(NSString *)downloadDestinationPath
                         progress:(void (^)(double fractionCompleted))progress
                   downloadMethod:(NSString *)downloadMethod
                 constructingBody:(void (^)(id formData))constructingBody;
@end

@implementation DBRequestParametersManager

- (instancetype)initWithURLString:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(NSString *errorDesc))failure
                      requestType:(DBRequestType)requestType
          downloadDestinationPath:(NSString *)downloadDestinationPath
                         progress:(void (^)(double fractionCompleted))progress
                   downloadMethod:(NSString *)downloadMethod
                 constructingBody:(void (^)(id formData))constructingBody
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.urlString = URLString;
    self.parameters = parameters;
    self.success = success;
    self.failure = failure;
    self.requestType = requestType;
    self.downloadDestinationPath = downloadDestinationPath;
    self.progress = progress;
    self.downloadMethod = downloadMethod;
    self.constructingBody = constructingBody;
    
    return self;
}

@end

#pragma mark -

@interface RefreshTokenManager : NSObject
@property (nonatomic, assign) NSUInteger refreshTimes;
@property (nonatomic, assign) BOOL isRefreshing;

- (void)tokenInvalid;
@end

@implementation RefreshTokenManager

+ (instancetype)sharedManager {
    static RefreshTokenManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [RefreshTokenManager new];
    });
    
    return _sharedManager;
}

- (void)completeWithCode:(NSInteger)code msg:(NSString *)msg token:(NSString *)token {
    if (code == 1) {
        [DBShareData sharedShareData].deviceInfo.token = token;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDBRefreshTokenResult object:nil userInfo:@{@"code":@(code),@"msg":msg,@"token":token?token:@""}];
    
    self.isRefreshing = NO;
}

- (NSDictionary *)refreshParameters {
    NSMutableDictionary *_refreshParameters = [NSMutableDictionary dictionary];
    
//    NSString *account = [[DBShareData sharedShareData].deviceInfo.account lowercaseString];
//    NSString *password = [DBShareData sharedShareData].deviceInfo.password;
//
//    _refreshParameters[@"name"] = account;
//    _refreshParameters[@"password"] = [JiaYuanEncrypt sha1Hash:[password dataUsingEncoding:NSUTF8StringEncoding]];
//    _refreshParameters[@"logmod"] = @"1";
//    _refreshParameters[@"deviceid"] = [[DBShareData sharedShareData] deviceID];
//    _refreshParameters[@"reallogin"] = @"0";
//    _refreshParameters[@"secucode"] = [JiaYuanEncrypt md5:[NSString stringWithFormat:@"%@%@",kSecuCode,account]];
//    _refreshParameters[@"dd"] = [JiaYuanEncrypt currentMachine];
//    _refreshParameters[@"ifa"] = [[DBShareData sharedShareData] idfa]?:@"";
//    _refreshParameters[@"ifa_tracking"] = [[DBShareData sharedShareData] idfaTracking];
//    _refreshParameters[@"osv"] = [[UIDevice currentDevice] systemVersion];
    
    return _refreshParameters;
}

- (void)refresh {
    if (self.refreshTimes == 0) {
        [self completeWithCode:-1 msg:@"" token:nil];
        return;
    }
    
    self.refreshTimes--;
    
    [[DBHTTPSessionManager sharedManager] POST:kURL_LOGIN parameters:FillParameters([self refreshParameters], [NSURL URLWithString:kURL_LOGIN]) progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [[(NSDictionary *)responseObject objectForKey:@"retcode"] integerValue];
//        [[ChatDataController sharedInstance] dealCMDMsg:(NSDictionary *)responseObject];
        if (ret != 1) {
            [self completeWithCode:-1 msg:@"" token:nil];
        } else {
            [self completeWithCode:1 msg:@"" token:[(NSDictionary *)responseObject objectForKey:@"token"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self refresh];
    }];
}

- (void)refreshToken {
    if (self.isRefreshing) {
        return;
    }
    
    self.isRefreshing = YES;
    self.refreshTimes = 2;
    
    [self refresh];
}

- (void)tokenInvalid {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDBTokenInvalid object:nil userInfo:nil];
    [self refreshToken];
}

@end

#pragma mark -

@interface DBRequestManager ()
@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) NSMutableDictionary *parametersManagerDictionary;
@property (nonatomic, strong) NSMutableDictionary *sessionTaskDictionary;
@property (nonatomic, strong) NSDictionary *additionalParameters;
@end

@implementation DBRequestManager

+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.httpSessionManager = [DBHTTPSessionManager sharedManager];
    self.parametersManagerDictionary = [NSMutableDictionary dictionary];
    self.sessionTaskDictionary = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenInvalid) name:kDBTokenInvalid object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTokenResult:) name:kDBRefreshTokenResult object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cancelAll];
}

- (BOOL)addRequestParametersManagerWithRequestID:(NSString *)requestID
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(id result))success
                                         failure:(void (^)(NSString *errorDesc))failure
                                     requestType:(DBRequestType)requestType
                         downloadDestinationPath:(NSString *)downloadDestinationPath
                                        progress:(void (^)(double fractionCompleted))progress
                                  downloadMethod:(NSString *)downloadMethod
                                constructingBody:(void (^)(id formData))constructingBody
{
    if ([self.parametersManagerDictionary objectForKey:requestID]) {
        return NO;
    }
    
    DBRequestParametersManager *parametersManager = [[DBRequestParametersManager alloc] initWithURLString:URLString parameters:parameters success:success failure:failure requestType:requestType downloadDestinationPath:downloadDestinationPath progress:progress downloadMethod:downloadMethod constructingBody:constructingBody];
    parametersManager.requestManager = self;
    [self.parametersManagerDictionary setObject:parametersManager forKey:requestID];
    
    if ([RefreshTokenManager sharedManager].isRefreshing) {
        return NO;
    }
    
    return YES;
}

- (void)removeRequestParametersManagerWithRequestID:(NSString *)requestID {
    [self.parametersManagerDictionary removeObjectForKey:requestID];
}

- (BOOL)addSessionTaskWithRequestID:(NSString *)requestID
                        sessionTask:(id)sessionTask
{
    if ([self.sessionTaskDictionary objectForKey:requestID]) {
        return NO;
    }
    
    [self.sessionTaskDictionary setObject:sessionTask forKey:requestID];
    
    return YES;
}

- (void)removeSessionTaskWithRequestID:(NSString *)requestID {
    [self.sessionTaskDictionary removeObjectForKey:requestID];
}

+ (UIViewController *)_topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (!rootViewController)
        rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        return [self _topViewControllerWithRootViewController:((UITabBarController *)rootViewController).selectedViewController];
    
    if ([rootViewController isKindOfClass:[UINavigationController class]])
        return [self _topViewControllerWithRootViewController:((UINavigationController *)rootViewController).visibleViewController];
    
    if (rootViewController.presentedViewController)
        return [self _topViewControllerWithRootViewController:rootViewController.presentedViewController];
    
    return rootViewController;
}

+ (UIViewController *)topViewController {
    return [self _topViewControllerWithRootViewController:nil];
}

- (void)dealSuccessRequest:(NSString *)requestID
            responseObject:(id)responseObject
                   success:(void (^)(id result))success
{
    id result = nil;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger retcode = [[(NSDictionary *)responseObject objectForKey:@"retcode"] integerValue];
        NSInteger code = [[(NSDictionary *)responseObject objectForKey:@"code"] integerValue];
        if (retcode == kDBRequestErrorTokenInvalid || code == kDBRequestErrorTokenInvalid) {
            [[RefreshTokenManager sharedManager] tokenInvalid];
            return;
        } else {
            NSInteger gocode = [[(NSDictionary *)responseObject objectForKey:@"gocode"] integerValue];
            if (gocode == 1) {
                NSMutableDictionary *mutableResponseObject = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                mutableResponseObject[@"go"] = @(-1);
                result = mutableResponseObject;
                
//                [kAppDelegate gotoView:0 withAddDict:[responseObject getDictionaryValueForKey:@"goinfo" defaultValue:nil] rootVc:[DBRequestManager topViewController]];
            } else {
                result = responseObject;
            }
        }
    } else if ([responseObject isKindOfClass:[NSArray class]]) {
        result = @{@"msg_list":responseObject,@"retcode":@"1"};
    } else if ([responseObject isKindOfClass:[NSURL class]]) {
        result = ((NSURL *)responseObject).path;
    }
    
    [self removeSessionTaskWithRequestID:requestID];
    [self removeRequestParametersManagerWithRequestID:requestID];
    
    if (success) {
        success(result);
    }
}

- (void)dealFailureRequest:(NSString *)requestID
                 errorDesc:(NSString *)errorDesc
                 errorCode:(NSInteger)errorCode
                   failure:(void (^)(NSString *errorDesc))failure
{
    if (errorCode == kDBRequestErrorCancelled) {
        return;
    }
    
    [self removeSessionTaskWithRequestID:requestID];
    [self removeRequestParametersManagerWithRequestID:requestID];
    
    if (failure) {
        failure(errorDesc);
    }
}

- (void)tokenInvalid {
    [self cancelAllRequest];
    [self clearAllTask];
}

- (NSString *)downloadDefaultPath:(NSString *)MIMEType requestID:(NSString *)requestID {
//    if ([MIMEType rangeOfString:@"image"].length) {
//        return [[JiaYuanLocalData getCurrentUserStoreageSubDirectory:@"Image"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",requestID]];
//    } else if ([MIMEType rangeOfString:@"zip"].length) {
//        return [[JiaYuanLocalData documentDirectoryPathWithName:@"Zip"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",requestID]];
//    } else if ([MIMEType rangeOfString:@"text"].length) {
//        return [[JiaYuanLocalData documentDirectoryPathWithName:@"Text"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_temp.txt",requestID]];
//    }
    
    return nil;
}

- (void)httpRequestWithType:(DBRequestType)requestType
                  URLString:(NSString *)URLString
                  requestID:(NSString *)requestID
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(id result))success
                    failure:(void (^)(NSString *errorDesc))failure
{
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        [self dealSuccessRequest:requestID responseObject:responseObject success:success];
    };
    void (^failureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        [self dealFailureRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
    };
    
    id sessionTask = nil;
    switch (requestType) {
        case DBRequestTypeGET:{
            sessionTask = [self.httpSessionManager GET:URLString parameters:FillParameters(parameters, [NSURL URLWithString:URLString]) progress:nil success:successBlock failure:failureBlock];
            [self.httpSessionManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask *task, NSError *error) {
//                NSLog(@"URLString=%@,error=%@,请求完成",URLString, error);
            }];
        }
            break;
        case DBRequestTypePOST:
            sessionTask = [self.httpSessionManager POST:URLString parameters:FillParameters(parameters, [NSURL URLWithString:URLString]) progress:nil success:successBlock failure:failureBlock];
            break;
            
        default:
            break;
    }
    if (sessionTask) {
        [self addSessionTaskWithRequestID:requestID sessionTask:sessionTask];
    }
}

- (void)downloadTask:(NSString *)URLString
           requestID:(NSString *)requestID
              method:(NSString *)method
          parameters:(NSDictionary *)parameters
     destinationPath:(NSString *)destinationPath
            progress:(void (^)(double fractionCompleted))progress
             success:(void (^)(id result))success
             failure:(void (^)(NSString *errorDesc))failure
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [self.httpSessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if (destinationPath) {
            return [NSURL fileURLWithPath:destinationPath];
        }
        
        NSString *defaultPath = [self downloadDefaultPath:response.MIMEType requestID:requestID];
        if (defaultPath) {
            return [NSURL fileURLWithPath:defaultPath];
        }
        
        return nil;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [self dealFailureRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
            return;
        }
        
        if (!filePath) {
            [self dealFailureRequest:requestID errorDesc:@"下载路径为空" errorCode:0 failure:failure];
            return;
        }
        
        if ([response.MIMEType rangeOfString:@"text"].length) {
            NSData *responseData = [[NSData alloc] initWithContentsOfFile:filePath.path];
            [[NSFileManager defaultManager] removeItemAtPath:filePath.path error:nil];
            
            if (!responseData) {
                [self dealFailureRequest:requestID errorDesc:@"响应数据为空" errorCode:0 failure:failure];
                return;
            }
            
            id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                [self dealFailureRequest:requestID errorDesc:@"数据格式错误" errorCode:0 failure:failure];
                return;
            }
            
            NSInteger retcode = [[(NSDictionary *)responseObject objectForKey:@"retcode"] integerValue];
            NSInteger code = [[(NSDictionary *)responseObject objectForKey:@"code"] integerValue];
            if (retcode == kDBRequestErrorTokenInvalid || code == kDBRequestErrorTokenInvalid) {
                [[RefreshTokenManager sharedManager] tokenInvalid];
            } else {
                [self dealFailureRequest:requestID errorDesc:[(NSDictionary *)responseObject objectForKey:@"msg"] errorCode:0 failure:failure];
            }
            
            return;
        }
        
        [self dealSuccessRequest:requestID responseObject:filePath success:success];
    }];
    [downloadTask resume];
    
    if (downloadTask) {
        [self addSessionTaskWithRequestID:requestID sessionTask:downloadTask];
    }
}

+ (void)appendPartForFormData:(id)formData
                     filePath:(NSString *)filePath
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
{
    if (!filePath) return;
    
    NSString *uploadName = name ? name : @"stream";
    NSString *uploadFileName = fileName ? fileName : [filePath lastPathComponent];
    NSString *uploadMIMEType = mimeType ? mimeType : @"application/octet-stream";
    
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:uploadName fileName:uploadFileName mimeType:uploadMIMEType error:nil];
}

+ (void)appendPartForFormData:(id)formData
                     fileData:(NSData *)data
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
{
    if (!data) return;
    
    NSString *uploadName = name ? name : @"stream";
    NSString *uploadMIMEType = mimeType ? mimeType : @"application/octet-stream";
    
    [formData appendPartWithFileData:data name:uploadName fileName:fileName mimeType:uploadMIMEType];
}

- (void)uploadTask:(NSString *)URLString
         requestID:(NSString *)requestID
        parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id formData))constructingBody
          progress:(void (^)(double fractionCompleted))progress
           success:(void (^)(id result))success
           failure:(void (^)(NSString *errorDesc))failure
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:FillParameters(parameters, [NSURL URLWithString:URLString]) constructingBodyWithBlock:constructingBody error:nil];
    
    NSString *tmpFileName = [NSString stringWithFormat:@"mlt_r_%f",[[NSDate date] timeIntervalSince1970]];
    NSURL *tmpFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName]];
    
    [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:request writingStreamContentsToFile:tmpFileURL completionHandler:^(NSError *error) {
        NSURLSessionUploadTask *uploadTask = [self.httpSessionManager uploadTaskWithRequest:request fromFile:tmpFileURL progress:^(NSProgress *uploadProgress) {
            if (progress) {
                progress(uploadProgress.fractionCompleted);
            }
        } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [[NSFileManager defaultManager] removeItemAtURL:tmpFileURL error:nil];
            
            if (error) {
                [self dealFailureRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
                return;
            }
            
            [self dealSuccessRequest:requestID responseObject:responseObject success:success];
        }];
        [uploadTask resume];
        
        if (uploadTask) {
            [self addSessionTaskWithRequestID:requestID sessionTask:uploadTask];
        }
    }];
}

- (void)refreshTokenResult:(NSNotification *)notification {
    NSInteger ret = [[notification.userInfo objectForKey:@"code"] integerValue];
    if (ret == 1) {
        NSArray *parametersManagerKeys = [self.parametersManagerDictionary allKeys];
        for (NSString *requestID in parametersManagerKeys) {
            DBRequestParametersManager *parametersManager = [self.parametersManagerDictionary objectForKey:requestID];
            
            NSMutableDictionary *newTokenParameters = [NSMutableDictionary dictionaryWithDictionary:parametersManager.parameters];
            newTokenParameters[@"token"] = [notification.userInfo objectForKey:@"token"];
            parametersManager.parameters = newTokenParameters;
            
            switch (parametersManager.requestType) {
                case DBRequestTypeGET:
                case DBRequestTypePOST:
                    [self httpRequestWithType:parametersManager.requestType URLString:parametersManager.urlString requestID:requestID parameters:parametersManager.parameters success:parametersManager.success failure:parametersManager.failure];
                    break;
                case DBRequestTypeDOWNLOAD:
                    [self downloadTask:parametersManager.urlString requestID:requestID method:parametersManager.downloadMethod parameters:parametersManager.parameters destinationPath:parametersManager.downloadDestinationPath progress:parametersManager.progress success:parametersManager.success failure:parametersManager.failure];
                    break;
                case DBRequestTypeUPLOAD:
                    [self uploadTask:parametersManager.urlString requestID:requestID parameters:parametersManager.parameters constructingBody:parametersManager.constructingBody progress:parametersManager.progress success:parametersManager.success failure:parametersManager.failure];
                    break;
                    
                default:
                    break;
            }
        }
    } else {
        NSArray *parametersManagerKeys = [self.parametersManagerDictionary allKeys];
        for (NSString *requestID in parametersManagerKeys) {
            DBRequestParametersManager *parametersManager = [self.parametersManagerDictionary objectForKey:requestID];
            [self removeRequestParametersManagerWithRequestID:requestID];
            if (parametersManager.failure) parametersManager.failure(@"刷token失败");
        }
    }
}

- (void)addParameters:(NSDictionary *)additionalParameters {
    _additionalParameters = additionalParameters;
}

- (NSDictionary *)fillAdditionalParameters:(NSDictionary *)originalParameters {
    if (!_additionalParameters || !originalParameters) return originalParameters;
    
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:originalParameters];
    NSArray *parametersKeys = [_additionalParameters allKeys];
    for (id key in parametersKeys) {
        [newParameters setObject:[_additionalParameters objectForKey:key] forKey:key];
    }
    return newParameters;
}

- (void)GET:(NSString *)URLString
  requestID:(NSString *)requestID
 parameters:(NSDictionary *)parameters
    success:(void (^)(id result))success
    failure:(void (^)(NSString *errorDesc))failure
{
    parameters = [self fillAdditionalParameters:parameters];
    
    BOOL result = [self addRequestParametersManagerWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestType:DBRequestTypeGET downloadDestinationPath:nil progress:nil downloadMethod:nil constructingBody:nil];
    if (!result) {
        return;
    }
    
    [self httpRequestWithType:DBRequestTypeGET URLString:URLString requestID:requestID parameters:parameters success:success failure:failure];
}

- (void)POST:(NSString *)URLString
   requestID:(NSString *)requestID
  parameters:(NSDictionary *)parameters
     success:(void (^)(id result))success
     failure:(void (^)(NSString *errorDesc))failure
{
    parameters = [self fillAdditionalParameters:parameters];
    
    BOOL result = [self addRequestParametersManagerWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestType:DBRequestTypePOST downloadDestinationPath:nil progress:nil downloadMethod:nil constructingBody:nil];
    if (!result) {
        return;
    }
    
    [self httpRequestWithType:DBRequestTypePOST URLString:URLString requestID:requestID parameters:parameters success:success failure:failure];
}

- (void)DOWNLOAD:(NSString *)URLString
       requestID:(NSString *)requestID
          method:(NSString *)method
      parameters:(NSDictionary *)parameters
 destinationPath:(NSString *)destinationPath
        progress:(void (^)(double fractionCompleted))progress
         success:(void (^)(id result))success
         failure:(void (^)(NSString *errorDesc))failure
{
    parameters = [self fillAdditionalParameters:parameters];
    
    BOOL result = [self addRequestParametersManagerWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestType:DBRequestTypeDOWNLOAD downloadDestinationPath:destinationPath progress:progress downloadMethod:method constructingBody:nil];
    if (!result) {
        return;
    }
    
    [self downloadTask:URLString requestID:requestID method:method parameters:parameters destinationPath:destinationPath progress:progress success:success failure:failure];
}

- (void)UPLOAD:(NSString *)URLString
     requestID:(NSString *)requestID
    parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id formData))constructingBody
      progress:(void (^)(double fractionCompleted))progress
       success:(void (^)(id result))success
       failure:(void (^)(NSString *errorDesc))failure
{
    parameters = [self fillAdditionalParameters:parameters];
    
    BOOL result = [self addRequestParametersManagerWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestType:DBRequestTypeUPLOAD downloadDestinationPath:nil progress:progress downloadMethod:nil constructingBody:constructingBody];
    if (!result) {
        return;
    }
    
    [self uploadTask:URLString requestID:requestID parameters:parameters constructingBody:constructingBody progress:progress success:success failure:failure];
}

- (BOOL)requestIsProcessing:(NSString *)requestID {
    if ([self.parametersManagerDictionary objectForKey:requestID]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)processingRequestCount {
    return [[self.parametersManagerDictionary allValues] count];
}

- (void)cancelAllRequest {
    NSArray *allTasks = [self.sessionTaskDictionary allValues];
    [allTasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)clearAllTask {
    [self.sessionTaskDictionary removeAllObjects];
}

- (void)clearAllParametersManager {
    [self.parametersManagerDictionary removeAllObjects];
}

- (void)cancelRequest:(NSString *)requestID {
    NSURLSessionTask *task = [self.sessionTaskDictionary objectForKey:requestID];
    [task cancel];
    [self removeSessionTaskWithRequestID:requestID];
    [self removeRequestParametersManagerWithRequestID:requestID];
}

- (void)cancelAll {
    [self cancelAllRequest];
    [self clearAllTask];
    [self clearAllParametersManager];
}

@end

#pragma mark -

@implementation DBHTTPResponseRequestManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.httpSessionManager = [DBHTTPResponseSessionManager sharedManager];
    
    return self;
}

@end

#pragma mark -

@implementation DBJSONRequestManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.httpSessionManager = [DBJSONRequestSessionManager sharedManager];
    
    return self;
}

@end

#pragma mark -

NSString * const DBNetworkingReachabilityDidChangeNotification = @"com.jiayuan.networking.reachability.change";
NSString * const DBNetworkingReachabilityNotificationStatusItem = @"DBNetworkingReachabilityNotificationStatusItem";

@interface DBNetworkReachabilityManager ()
@property (nonatomic, strong) AFNetworkReachabilityManager *afNetworkReachabilityManager;
@property (nonatomic, copy) void (^statusChangeBlock)(DBNetworkReachabilityStatus status);
@end

@implementation DBNetworkReachabilityManager

+ (instancetype)sharedManager {
    static DBNetworkReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
        _sharedManager.afNetworkReachabilityManager = [AFNetworkReachabilityManager manager];
    });
    
    return _sharedManager;
}

- (void)dealloc {
    [self stopMonitoring];
}

- (void)setReachabilityStatusChangeBlock:(void (^)(DBNetworkReachabilityStatus status))block {
    if (self.statusChangeBlock) {
        return;
    }
    
    self.statusChangeBlock = block;
}

- (void)startMonitoring {
    __weak __typeof(self)weakSelf = self;
    [_afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.statusChangeBlock) {
            strongSelf.statusChangeBlock([strongSelf convertStatus:status]);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    [_afNetworkReachabilityManager startMonitoring];
}

- (void)stopMonitoring {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_afNetworkReachabilityManager stopMonitoring];
}

- (DBNetworkReachabilityStatus)convertStatus:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return DBNetworkReachabilityStatusNotReachable;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return DBNetworkReachabilityStatusReachableViaWWAN;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return DBNetworkReachabilityStatusReachableViaWiFi;
        case AFNetworkReachabilityStatusUnknown:
        default:
            return DBNetworkReachabilityStatusUnknown;
    }
}

- (DBNetworkReachabilityStatus)currentStatus {
    return [self convertStatus:_afNetworkReachabilityManager.networkReachabilityStatus];
}

- (BOOL)isReachable {
    return [_afNetworkReachabilityManager isReachable];
}

- (void)statusChangeNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AFNetworkReachabilityStatus status = [[userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    DBNetworkReachabilityStatus newStatus = [self convertStatus:status];
    [[NSNotificationCenter defaultCenter] postNotificationName:DBNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ DBNetworkingReachabilityNotificationStatusItem: @(newStatus) }];
}

@end
