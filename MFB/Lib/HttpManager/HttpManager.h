//
//  HttpManager.h
//  MdfOA
//
//  Created by snowflake1993922 on 15/7/27.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

typedef void(^CompletionBlockWithTime)(id result,long timeDiff,NSString *networkTime);
typedef void(^CompletionBlock)(id result);
typedef void(^FailureBlock)(id result);

@interface NSString (HttpManager)
- (NSString *)encode;
- (NSString *)decode;
- (NSString *)URLEncodedString;
- (id)object;

@end

@interface NSObject (HttpManager)
- (NSString *)json;
@end

@interface HttpManager : NSObject
//@property(nonatomic, strong) AFHTTPRequestOperation *upLoadOperation;
//@property(nonatomic, strong) AFHTTPRequestOperation *downLoadOperation;
@property(nonatomic, assign) float downLoadProgress;
@property(nonatomic, assign) float upLoadProgress;

+ (HttpManager *)defaultManager;

/*  -------判断当前的网络类型----------
 1、NotReachable     - 没有网络连接
 2、ReachableViaWWAN - 移动网络(2G、3G)
 3、ReachableViaWiFi - WIFI网络
 */
+ (NetworkStatus)networkStatus;

-(void)cancelAllOperationHttp;

///////////////////////////////////////////////////////////////////////////////
/**
 *  AFNetworking请求数据
 *  @param urlString 接口地址(不完整)
 *  @param headers   请求头信息
 *  @param params    参数
 *  @param method    请求的方式
 *  @param block     回调block
 *  @param datas     要上传的数据,保存在数组中
 *  @param view      提示信息显示的界面
 *  @return session的datatask任务
 */
+ (NSURLSessionDataTask *)afRequestWithURL:(NSString *)urlString
                               httpHeaders:(NSString *)headers
                                    params:(NSMutableDictionary *)params
                                      data:(NSMutableDictionary *)datas
                               tipMessage:(UIView *)view
                                httpMethod:(NSString *)method
                                completion:(CompletionBlock)block;

/**
 *  AFNetworking请求数据*****************添加一个错误回调
 *  @param urlString 接口地址(不完整)
 *  @param headers   请求头信息
 *  @param params    参数
 *  @param method    请求的方式
 *  @param block     回调block
 *  @param datas     要上传的数据,保存在数组中
 *  @param failureBlock     出错的回调
 *
 *  @return session的datatask任务
 */
+ (NSURLSessionDataTask *)afRequestWithURL:(NSString *)urlString
                               httpHeaders:(NSString *)headers
                                    params:(NSMutableDictionary *)params
                                      data:(NSMutableDictionary *)datas
                                tipMessage:(UIView *)view
                                httpMethod:(NSString *)method
                                completion:(CompletionBlock)block
                                   failure:(FailureBlock)failureBlock;

/**
 *  AFNetworking请求数据*****************添加一个错误回调
 *  @param urlString 接口地址(不完整)
 *  @param headers   请求头信息
 *  @param params    参数
 *  @param method    请求的方式
 *  @param block     回调block
 *  @param datas     要上传的数据,保存在数组中
 *  @param failureBlock     出错的回调
 *
 *  @return session的datatask任务
 */
+ (NSURLSessionDataTask *)afRequestWithURL2:(NSString *)urlString
                                httpHeaders:(NSString *)headers
                                     params:(NSMutableDictionary *)params
                                       data:(NSMutableDictionary *)datas
                                 tipMessage:(UIView *)view
                                 httpMethod:(NSString *)method
                                 completion:(CompletionBlockWithTime)block
                                    failure:(FailureBlock)failureBlock;
///////////////////////////////////////////////////////////////////////////////


//GET 请求
- (void)getRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete;

//如果有本地缓存数据直接从缓存读取，没有则从服务器端获取
- (void)localCacheToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete;

//未联网时使用缓存数据
- (void)getCacheToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete;

//POST 请求
- (void)postRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete;


#pragma mark - 下载相关操作

/*
 filePath : 下载文件的存储路径
 response : 接口返回的不是文件而是json数据
 process  : 进度
 */
//AFHTTPRequestOperation可以暂停、重新开启、取消 [operation pause]、[operation resume];、[operation cancel];
- (AFHTTPRequestOperation *)downloadFromUrl:(NSString *)url
                                   filePath:(NSString *)filePath
                                   complete:(void (^)(BOOL successed, id response))complete;



//可以查看进度 process_block
- (AFHTTPRequestOperation *)downloadFromUrl:(NSString *)url
                                     params:(NSDictionary *)params
                                   filePath:(NSString *)filePath
                                    process:(void (^)(NSInteger readBytes, NSInteger totalBytes))process
                                   complete:(void (^)(BOOL successed, id response))complete;


#pragma mark - 上传相关操作

/*
 files : 需要上传的文件数组，数组里为多个字典
 字典里的key:
 1、name: 文件名称（如：demo.jpg）
 2、file: 文件   （支持四种数据类型：NSData、UIImage、NSURL、NSString）NSURL、NSString为文件路径
 3、key : 文件对应字段的key（默认：file）
 4、type: 文件类型（默认：image/jpeg）
 示例： @[@{@"file":_headImg.currentBackgroundImage,@"name":@"head.jpg"}];
 */

//AFHTTPRequestOperation可以暂停、重新开启、取消 [operation pause]、[operation resume];、[operation cancel];
- (AFHTTPRequestOperation *)uploadToUrl:(NSString *)url
                params:(NSDictionary *)params
                 files:(NSArray *)files
              complete:(void (^)(BOOL successed, id result))complete;




//可以查看进度 process_block
- (AFHTTPRequestOperation *)uploadToUrl:(NSString *)url
                params:(NSDictionary *)params
                 files:(NSArray *)files
               process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process
              complete:(void (^)(BOOL successed, id result))complete;


#pragma mark - 新的上传下载方法
@property(nonatomic , strong) NSURL* url;
@property(nonatomic , copy) NSString* (^cachePath)(void);
@property(nonatomic , strong) AFHTTPRequestOperation *requestOperation;
@property(nonatomic , copy) void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);


-(void)downloadWithUrl:(id)url
                params:(NSDictionary *)params
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)uploadWithUrl:(id)url
              params:(NSDictionary *)params
               files:(NSArray *)files
           cachePath:(NSString* (^) (void))cacheBlock
       progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
