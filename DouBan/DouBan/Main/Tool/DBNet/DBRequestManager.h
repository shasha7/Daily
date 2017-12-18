//
//  DBRequestManager.h
//  DBNetworking
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBRequestManager : NSObject

///---------------
/// @name 初始化方法
///---------------

/**
 初始化一个DBRequestManager实例并返回
 */
+ (instancetype)manager;

/**
 给整个manager实例添加自定义统一参数
 */
- (void)addParameters:(NSDictionary *)additionalParameters;

///------------------
/// @name HTTP请求方法
///------------------

/**
 GET请求
 
 @param requestID 请求标识，同一个标识的请求返回前只请求一次，对于同一个DBRequestManager中不同的网络请求标识必须不同
 @param success 请求成功调用block，其中result为已解析完成的返回数据
 @param failure 请求失败调用block，其中errorDesc为请求失败原因
 */
- (void)GET:(NSString *)URLString
  requestID:(NSString *)requestID
 parameters:(nullable NSDictionary *)parameters
    success:(nullable void (^)(id _Nullable result))success
    failure:(nullable void (^)(NSString *errorDesc))failure;

/**
 POST请求
 */
- (void)POST:(NSString *)URLString
  requestID:(NSString *)requestID
 parameters:(nullable NSDictionary *)parameters
    success:(nullable void (^)(id _Nullable result))success
    failure:(nullable void (^)(NSString *errorDesc))failure;

///--------------
/// @name 下载任务
///--------------

/**
 下载请求
 
 @param method 选择用GET或POST请求下载
 @param destinationPath 下载目标路径，不传下载至默认路径
 @param progress 下载进度block
 @param success 下载成功调用block，其中result为下载文件存储路径
 */
- (void)DOWNLOAD:(NSString *)URLString
       requestID:(NSString *)requestID
          method:(NSString *)method
      parameters:(nullable NSDictionary *)parameters
 destinationPath:(nullable NSString *)destinationPath
        progress:(nullable void (^)(double fractionCompleted))progress
         success:(nullable void (^)(id result))success
         failure:(nullable void (^)(NSString *errorDesc))failure;

///--------------
/// @name 表单构建
///--------------

/**
 通过文件路径构建表单
 
 @param formData 需要构建的表单
 @param filePath 文件路径，必传
 @param name 表单中name的值，不传默认为stream
 @param fileName 表单中filename的值，不传默认为文件名
 @param mimeType 表单中Content-Type的值，不传默认为application/octet-stream
 */
+ (void)appendPartForFormData:(id)formData
                     filePath:(NSString *)filePath
                         name:(nullable NSString *)name
                     fileName:(nullable NSString *)fileName
                     mimeType:(nullable NSString *)mimeType;

/**
 通过文件数据构建表单
 
 @param data 文件数据，必传
 @param fileName 表单中filename的值，必传
 */
+ (void)appendPartForFormData:(id)formData
                     fileData:(NSData *)data
                         name:(nullable NSString *)name
                     fileName:(nullable NSString *)fileName
                     mimeType:(nullable NSString *)mimeType;

///--------------
/// @name 上传任务
///--------------

/**
 上传请求
 
 @param constructingBody 配合表单构建方法使用
 */
- (void)UPLOAD:(NSString *)URLString
     requestID:(NSString *)requestID
    parameters:(nullable NSDictionary *)parameters
constructingBody:(void (^)(id formData))constructingBody
      progress:(nullable void (^)(double fractionCompleted))progress
       success:(nullable void (^)(id _Nullable result))success
       failure:(nullable void (^)(NSString *errorDesc))failure;

///------------------------
/// @name 网络请求是否正在进行
///------------------------

/**
 查询某个网络请求是否正在进行
 
 @return 正在进行的网络请求返回YES，否则为NO
 */
- (BOOL)requestIsProcessing:(NSString *)requestID;

///-------------------
/// @name 当前网络请求数
///-------------------

/**
 获取正在进行的网络请求数
 */
- (NSUInteger)processingRequestCount;

///--------------
/// @name 取消请求
///--------------

/**
 取消单个网络请求
 */
- (void)cancelRequest:(NSString *)requestID;

/**
 取消所有网络请求
 */
- (void)cancelAll;

@end

/**
 `DBHTTPResponseRequestManager` is a subclass of `DBRequestManager` without JSON validation.
 */
@interface DBHTTPResponseRequestManager : DBRequestManager

@end

/**
 `DBJSONRequestManager` is a subclass of `DBRequestManager` with `JSONRequestSerializer`.
 */
@interface DBJSONRequestManager : DBRequestManager

@end

typedef NS_ENUM(NSInteger, DBNetworkReachabilityStatus) {
    DBNetworkReachabilityStatusUnknown          = -1,
    DBNetworkReachabilityStatusNotReachable     = 0,
    DBNetworkReachabilityStatusReachableViaWWAN = 1,
    DBNetworkReachabilityStatusReachableViaWiFi = 2,
};

/**
 `DBNetworkReachabilityManager` is encapsulated by using `AFNetworkReachabilityManager`.
 */
@interface DBNetworkReachabilityManager : NSObject

///---------------------
/// @name Initialization
///---------------------

/**
 Returns the shared network reachability manager.
 */
+ (instancetype)sharedManager;

///---------------------------------------------------
/// @name Setting Network Reachability Change Callback
///---------------------------------------------------

/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
 */
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(DBNetworkReachabilityStatus status))block;

///--------------------------------------------------
/// @name Starting & Stopping Reachability Monitoring
///--------------------------------------------------

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoring;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

///-------------------------------------------
/// @name Querying Network Reachability Status
///-------------------------------------------

/**
 @return The current network reachability status.
 */
- (DBNetworkReachabilityStatus)currentStatus;

/**
 Whether or not the network is currently reachable.
 */
- (BOOL)isReachable;

@end

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when network reachability changes.
 This notification assigns no notification object. The `userInfo` dictionary contains an `NSNumber` object under the `DBNetworkingReachabilityNotificationStatusItem` key, representing the `DBNetworkReachabilityStatus` value for the current network reachability.
 */
FOUNDATION_EXPORT NSString * const DBNetworkingReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const DBNetworkingReachabilityNotificationStatusItem;

NS_ASSUME_NONNULL_END
