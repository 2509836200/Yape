//
//  HttpManager.m
//  MdfOA
//
//  Created by snowflake1993922 on 15/7/27.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "HttpManager.h"
#import "NSDate+InternetDateTime.h"
//#import "SVProgressHUD.h"

@implementation NSString (HttpManager)
- (NSString *)encode
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString *)decode
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (id)object
{
    id object = nil;
    @try {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];;
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] JSON字符串转换成对象出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    return object;
}

@end


@implementation NSObject (HttpManager)
- (NSString *)json
{
    NSString *jsonStr = @"";
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] 对象转换成JSON字符串出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    return jsonStr;
}


@end


@interface HttpManager ()
{
    AFHTTPRequestOperationManager *operationManager;
}
@end

@implementation HttpManager


- (id)init{
    self = [super init];
    if (self) {
        operationManager = [AFHTTPRequestOperationManager manager];
        operationManager.responseSerializer.acceptableContentTypes = nil;
        
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        [urlCache setMemoryCapacity:50*1024*1024];  /* 设置缓存的大小为50M*/
        [NSURLCache setSharedURLCache:urlCache];
    }
    return self;
}


+ (HttpManager *)defaultManager
{
    static dispatch_once_t pred = 0;
    __strong static id defaultHttpManager = nil;
    dispatch_once( &pred, ^{
        defaultHttpManager = [[self alloc] init];
    });
    return defaultHttpManager;
}

-(void)cancelAllOperationHttp
{
    [operationManager.operationQueue cancelAllOperations];
    NSLog(@"取消所有的 operationQueue请求");
}

///////////////////////////////////////////////////////////////////////////////
/**
 *  AFNetworking请求数据
 *  @param urlString 接口地址(不完整)
 *  @param headers   请求头信息
 *  @param params    参数
 *  @param method    请求的方式
 *  @param block     回调block
 *  @param datas     要上传的数据,保存在数组中
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
{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //3.构造AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //4.序列化方式
    //序列化response
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [userDefaults objectForKey:@"sessionId"];
    NSLog(@"`~~~~~~~~~~%@",sessionId);
    
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    
    
    NSURLSessionDataTask *task = nil;
    
    //5.发送请求
    if ([method isEqualToString:@"GET"])
    {
        if (IS_NOT_EMPTY(headers))
        {
            NSMutableURLRequest *request;
            NSMutableString *paramString = [NSMutableString string];
            //取出所有的key
            NSArray *allKeys = [params allKeys];
            for (int i = 0; i < allKeys.count; i ++)
            {
                NSString *key = [allKeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                //key=value&key2=value2
                [paramString appendFormat:@"%@=%@",key,value];
                if (i < (params.count - 1))
                {
                    [paramString appendString:@"&"];
                }
            }
            NSString *endURLString = [NSString stringWithFormat:@"%@?%@",fullURLString,paramString];
            if (IS_NOT_EMPTY(paramString))
            {
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endURLString]];
            }
            else
            {
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURLString]];
            }
            [request setValue:sessionId forHTTPHeaderField:headers];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //回到主线程刷新UI界面
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                return;
            }];
            [operation start];
        }
        
        else
        {
            //GET请求, 设置参数
            task = [manager GET:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                //回到主线程刷新UI界面
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSString *time =response.allHeaderFields[@"Date"];
                    NSDate* inputDate = [NSDate dateFromRFC822String:time];
                    NSDate *localTime =[AdaptInterface getNowDateFromatAnDate:inputDate];
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error:%@",error);
                
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                return;
            }];
            
        }
    }
    else if ([method isEqualToString:@"POST"])
    {
        //POST请求
        if (datas == nil)
        {
            //没有请求体
            task = [manager POST:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                return;
            }];
            
        }
        else
        {
            //有上传的数据（图片）
            task = [manager POST:fullURLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                //datas key:data
                //构造请求体
                for (NSString *key in datas)
                {
                    //要上传的每一条数据
                    //key(key)=value(data)
                    NSData *data = [datas objectForKey:key];
                    
                    //data: 要添加的数据
                    //name: 数据对应的key
                    //filename: 服务器可以接受的文件名
                    //mimeType: 文件的类型
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:@"file"
                                            mimeType:@"image/jpeg"];
                }
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
            }];
        }
    }
    
    return task;
}

///////////////////////////////////////////////////////////////////////////////
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
                                failure:(FailureBlock)failureBlock

{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //3.构造AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =15;

    //4.序列化方式
    //序列化response
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [userDefaults objectForKey:@"sessionId"];
    
    
    
    
    NSURLSessionDataTask *task = nil;
    
    //5.发送请求
    if ([method isEqualToString:@"GET"])
    {
        if (IS_NOT_EMPTY(headers))
        {
            NSMutableURLRequest *request;
            NSMutableString *paramString = [NSMutableString string];
            //取出所有的key
            NSArray *allKeys = [params allKeys];
            for (int i = 0; i < allKeys.count; i ++)
            {
                NSString *key = [allKeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                //key=value&key2=value2
                [paramString appendFormat:@"%@=%@",key,value];
                if (i < (params.count - 1))
                {
                    [paramString appendString:@"&"];
                }
            }
            NSString *endURLString = [NSString stringWithFormat:@"%@?%@",fullURLString,paramString];
            if (IS_NOT_EMPTY(paramString))
            {
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endURLString]];
            }
            else
            {
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURLString]];
            }
            [request setValue:sessionId forHTTPHeaderField:headers];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //回到主线程刷新UI界面
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(@(error.code));
                });
                return;
            }];
            [operation start];
        }
        
        else
        {
            //GET请求, 设置参数
            task = [manager GET:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                //回到主线程刷新UI界面
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error:%@",error);
                
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(@(error.code));
                });
                return;
            }];
            
        }
    }
    else if ([method isEqualToString:@"POST"])
    {
        //POST请求
        if (datas == nil)
        {
            [manager.requestSerializer setValue:sessionId forHTTPHeaderField:headers];
            //没有请求体
            task = [manager POST:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(@(error.code));
                });
                return;
            }];
            
        }
        else
        {
            //有上传的数据（图片）
            task = [manager POST:fullURLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                //datas key:data
                //构造请求体
                for (NSString *key in datas)
                {
                    //要上传的每一条数据
                    //key(key)=value(data)
                    NSData *data = [datas objectForKey:key];
                    
                    //data: 要添加的数据
                    //name: 数据对应的key
                    //filename: 服务器可以接受的文件名
                    //mimeType: 文件的类型
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:@"file"
                                            mimeType:@"image/jpeg"];
                }
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                //拿到请求结果,回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
                if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                    
                    [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
                }
                else if(error.code == kCFURLErrorTimedOut){
                    
                    [AdaptInterface tipMessageTitle:@"请求超时" view:view];
                }
                else{
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:view];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(@(error.code));
                });
            }];
        }
    }
    
    return task;
}

///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
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
                                   failure:(FailureBlock)failureBlock

{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //3.构造AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    //4.序列化方式
    //序列化response
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    
    
    NSURLSessionDataTask *task = nil;
    
    //GET请求, 设置参数
    task = [manager GET:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //回到主线程刷新UI界面
        //拿到请求结果,回调
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSString *time =response.allHeaderFields[@"Date"];
            NSDate* inputDate = [NSDate dateFromRFC822String:time];
            NSDate *loac =[NSDate date];
            //NSDate *localTime =[AdaptInterface getNowDateFromatAnDate:inputDate];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *networkTime = [dateFormatter stringFromDate:inputDate];
            
            NSTimeInterval differTime = (long)[inputDate timeIntervalSinceDate:[NSDate date]];
            block(responseObject,differTime,networkTime);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
        
        [SVProgressHUD dismiss];
        if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
            
            [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
        }
        else if(error.code == kCFURLErrorTimedOut){
            
            [AdaptInterface tipMessageTitle:@"请求超时" view:view];
        }
        else{
            
            [AdaptInterface tipMessageTitle:@"操作失败" view:view];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(@(error.code));
        });
        return;
    }];
    return task;
}


//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
+ (NSDate *)getLocalFromUTC:(NSString *)utc

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *ldate = [dateFormatter dateFromString:utc];
    
    
    return ldate;
    
}
//GET 请求
- (void)getRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete
{
    [self requestToUrl:url method:@"GET" useCache:NO params:params complete:complete];
}
//未联网时使用缓存数据
- (void)getCacheToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete
{
    [self requestToUrl:url method:@"GET" useCache:YES params:params complete:complete];
}
//POST 请求
- (void)postRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete
{
    [self requestToUrl:url method:@"POST" useCache:NO params:params complete:complete];
}

- (NSMutableURLRequest *)requestWithUrl:(NSString *)url method:(NSString *)method useCache:(BOOL)useCache params:(NSDictionary *)params
{
    params = [[HttpManager getRequestBodyWithParams:params] copy];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:url parameters:params error:nil];
    
    [request setTimeoutInterval:10];
    if ([HttpManager networkStatus] == NotReachable) {
        if (useCache) {
            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            
        }
        
    }
    return request;
}

- (id)dictionaryWithData:(id)data
{
    id object = data;
    if ([data isKindOfClass:[NSData class]]) {
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    if ([data isKindOfClass:[NSString class]]) {
        object = [data object];
    }
    return object?:data;
}
//如果有本地缓存数据直接从缓存读取，没有则从服务器端获取
- (void)localCacheToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, id result))complete
{
    NSMutableURLRequest *request = [self requestWithUrl:url method:@"GET" useCache:true params:params];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        complete ? complete(true, [self dictionaryWithData:cachedResponse.data]) : nil;
    } else {
        [self getCacheToUrl:url params:params complete:complete];
    }
}

- (void)requestToUrl:(NSString *)url method:(NSString *)method useCache:(BOOL)useCache params:(NSDictionary *)params complete:(void (^)(BOOL successed, NSDictionary *result))complete
{
    NSMutableURLRequest *request = [self requestWithUrl:url method:method useCache:useCache params:params];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }
    
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    
    void (^requestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self logWithOperation:operation method:method params:params];
        complete ? complete(true,[self dictionaryWithData:responseObject]) : nil;
    };
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self logWithOperation:operation method:method params:params];
        complete ? complete(false,nil) : nil;
    };
    
    AFHTTPRequestOperation *operation = nil;
    if ([HttpManager networkStatus] == NotReachable) {
        if (useCache) {
            operation = [self cacheOperationWithRequest:request success:requestSuccessBlock failure:requestFailureBlock];
        }else{
            operation = [operationManager HTTPRequestOperationWithRequest:request success:requestSuccessBlock failure:requestFailureBlock];
        }
        
        
    }else{
        operation = [operationManager HTTPRequestOperationWithRequest:request success:requestSuccessBlock failure:requestFailureBlock];
        
    }
    //    if (useCache) {
    //        operation = [self cacheOperationWithRequest:request success:requestSuccessBlock failure:requestFailureBlock];
    //    }else{
    //        operation = [operationManager HTTPRequestOperationWithRequest:request success:requestSuccessBlock failure:requestFailureBlock];
    //    }
    [operationManager.operationQueue addOperation:operation];
}

- (AFHTTPRequestOperation *)cacheOperationWithRequest:(NSURLRequest *)urlRequest
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject){
       __strong NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
        
        //store in cache
        cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
        [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:urlRequest];
        
        success(operation,responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
            if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
                success(operation, cachedResponse.data);
            } else {
                failure(operation, error);
            }
        } else {
            failure(operation, error);
        }
    }];
    
    return operation;
}

- (void)logWithOperation:(AFHTTPRequestOperation *)operation method:(NSString *)method params:(NSDictionary *)params
{
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        NSLog(@"get request url:  %@  \n",[operation.request.URL.absoluteString decode]);
    }else{
        NSLog(@"%@ request url:  %@  \npost params:  %@\n",[method lowercaseString],[operation.request.URL.absoluteString decode],params);
    }
    if (operation.error) {
        NSLog(@"%@ error :  %@,%@",[method lowercaseString],operation.error,[operation.responseString object]?:operation.responseString);
    }else{
        id response=nil;
        response = [operation.responseString object]?:operation.responseString;
        //   LLog(@"%@ responseObject:  %@",[method lowercaseString],response);
    }
}

#pragma mark - 下载相关操作


/*
 filePath : 下载文件的存储路径
 response : 接口返回的不是文件而是json数据
 process  : 进度
 */

//AFHTTPRequestOperation可以暂停、重新开启、取消 [operation pause]、[operation resume];、[operation cancel];
- (AFHTTPRequestOperation *)downloadFromUrl:(NSString *)url
                                   filePath:(NSString *)filePath
                                   complete:(void (^)(BOOL successed, id response))complete
{
    return [self downloadFromUrl:url params:nil filePath:filePath process:nil complete:complete];
}

- (AFHTTPRequestOperation *)downloadFromUrl:(NSString *)url
                                     params:(NSDictionary *)params
                                   filePath:(NSString *)filePath
                                    process:(void (^)(NSInteger readBytes, NSInteger totalBytes))process
                                   complete:(void (^)(BOOL successed, id response))complete
{
    _downLoadProgress = 0;
    //[SVProgressHUD showProgress:_downLoadProgress status:@"Loading"];
    sleep(1);

    _downLoadProgress+=0.01f;

    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    NSLog(@"get request url: %@",[request.URL.absoluteString decode]);
    
    AFHTTPRequestOperation *downLoadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    downLoadOperation.responseSerializer.acceptableContentTypes = nil;
    
    NSString *tmpPath = filePath;
    //NSString *tmpPath = [filePath stringByAppendingString:@".tmp"];
    downLoadOperation.outputStream=[[NSOutputStream alloc] initToFileAtPath:tmpPath append:NO];

    [downLoadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *mimeTypeArray = @[@"text/html", @"application/json"];
        NSError *moveError = nil;
        if ([mimeTypeArray containsObject:operation.response.MIMEType]) {
            //返回的是json格式数据
            responseObject = [self dictionaryWithData:[NSData dataWithContentsOfFile:tmpPath]];
            NSLog(@"---------------%@",responseObject);
            //[[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
            //[[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:filePath error:&moveError];
            //NSLog(@"get responseObject:  %@",responseObject);
        }else{
            //[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            //[[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:filePath error:&moveError];
        }
        
        if (complete && !moveError) {
            complete(true,responseObject);
        }else{
            complete?complete(false,responseObject):nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get error :  %@",error);
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        if (complete) {
            complete(false,nil);
        }
    }];
    
    [downLoadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {

        _downLoadProgress = totalBytesRead/totalBytesExpectedToRead;
        //[SVProgressHUD showProgress:_downLoadProgress status:@"Loading"];

        NSLog(@"download process: %.2lld%% (%ld/%ld)",100*totalBytesRead/totalBytesExpectedToRead,(long)totalBytesRead,(long)totalBytesExpectedToRead);
        if (process) {
            process(totalBytesRead,totalBytesExpectedToRead);
        }
        
    }];
    
    [downLoadOperation start];
    
    return downLoadOperation;
}


+ (NSMutableDictionary *)getRequestBodyWithParams:(NSDictionary *)params
{
    NSMutableDictionary *requestBody = params?[params mutableCopy]:[[NSMutableDictionary alloc] init];
    
    for (NSString *key in [params allKeys]){
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDate class]]) {
            [requestBody setValue:@([value timeIntervalSince1970]*1000) forKey:key];
        }
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            [requestBody setValue:[value json] forKey:key];
        }
    }
    
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    //    if (token){
    //        [requestBody setObject:token forKey:@"token"];
    //    }
    //[requestBody setObject:@"ios" forKey:@"from"];
    
    return requestBody;
}

+ (NetworkStatus)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    // NotReachable     - 没有网络连接
    // ReachableViaWWAN - 移动网络(2G、3G)
    // ReachableViaWiFi - WIFI网络
    return [reachability currentReachabilityStatus];
}

#pragma mark - 上传相关操作

//AFHTTPRequestOperation可以暂停、重新开启、取消 [operation pause]、[operation resume];、[operation cancel];
- (AFHTTPRequestOperation *)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                               complete:(void (^)(BOOL successed, id result))complete
{
    return [self uploadToUrl:url params:params files:files process:nil complete:complete];
}
//可以查看进度 process_block
- (AFHTTPRequestOperation *)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                                process:(void (^)(NSInteger writedBytes, NSInteger totalBytes))process
                               complete:(void (^)(BOOL successed, id result))complete
{
    //_upLoadProgress = 0;
    //[SVProgressHUD showProgress:_upLoadProgress status:@"Loading"];
    //sleep(1);
    
    //_upLoadProgress+=0.01f;t
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:url];
    
    params = [[HttpManager getRequestBodyWithParams:params] copy];
    NSLog(@"post request url:  %@  \npost params:  %@",url,params);
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:fullURLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *fileItem in files) {
            id value = [fileItem objectForKey:@"file"];        //支持四种数据类型：NSData、UIImage、NSURL、NSString
            NSString *name = [fileItem objectForKey:@"key"];            //文件字段的key
            NSString *fileName = [fileItem objectForKey:@"name"];       //文件名称
            NSString *mimeType = [fileItem objectForKey:@"type"];       //文件类型
            mimeType = mimeType ? mimeType : @"image/jpeg";
            name = name ? name : @"file";
            NSLog(@"%@",name);
            if ([value isKindOfClass:[NSData class]])
            {
                [formData appendPartWithFileData:value name:name fileName:fileName mimeType:mimeType];
            }else if ([value isKindOfClass:[UIImage class]])
            {
               
                if (UIImagePNGRepresentation(value) == nil)
                {  //返回为png图像。
                    [formData appendPartWithFileData:UIImagePNGRepresentation(value) name:name fileName:fileName mimeType:mimeType];
                }else
                {   //返回为JPEG图像。
                    NSData *data =UIImageJPEGRepresentation(value, 0.5);
                    NSLog(@"------%lu",(unsigned long)data.length);
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:name fileName:fileName mimeType:mimeType];
                }
            }else if ([value isKindOfClass:[NSURL class]])
            {
                [formData appendPartWithFileURL:value name:name fileName:fileName mimeType:mimeType error:nil];
            }else if ([value isKindOfClass:[NSString class]])
            {
                [formData appendPartWithFileURL:[NSURL URLWithString:value]  name:name fileName:fileName mimeType:mimeType error:nil];
            }
        }
    } error:nil];
    
    AFHTTPRequestOperation *upLoadOperation = nil;
    upLoadOperation = [operationManager HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              id response = [operation.responseString object]?:operation.responseString;
                                                              NSLog(@"post responseObject:  %@",response);
                                                              if (complete) {
                                                                  complete(true,[self dictionaryWithData:responseObject]);
                                                              }
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              NSLog(@"post error :  %@",error);
                                                              NSLog(@"post responseObject:  %@",operation.responseString);
                                                              if (complete) {
                                                                  complete(false,nil);
                                                              }
                                                          }];
    
    [upLoadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
        
        NSLog(@"upload process: %.2lld%% (%ld/%ld)",100*totalBytesWritten/totalBytesExpectedToWrite,(long)totalBytesWritten,(long)totalBytesExpectedToWrite);
        if (process)
        {
            process(totalBytesWritten,totalBytesExpectedToWrite);
        }

    }];

    [upLoadOperation start];
    
    return upLoadOperation;
    
}


#pragma mark - 新的上传下载方法

#pragma mark - 下载
-(void)downloadWithUrl:(id)url
                params:(NSDictionary *)params
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    self.cachePath = cacheBlock;
    //获取缓存的长度
    long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
    
    NSLog(@"cacheLength = %llu",cacheLength);
    
    //获取请求
    NSMutableURLRequest* request = [[self class] requestWithUrl:url Range:cacheLength];
    
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.requestOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:self.cachePath() append:NO]];
    
    //处理流
    [self readCacheToOutStreamWithPath:self.cachePath()];
    
    //添加观察者，监听“暂停”
    [self.requestOperation addObserver:self forKeyPath:@"isPaused" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    //获取进度块
    self.progressBlock = progressBlock;
    
    
    //重组进度块block
    [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    
    
    //获取成功回调块
    void (^newSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseHead = %@",[operation.response allHeaderFields]);
        
        success(operation,responseObject);
    };
    
    
    [self.requestOperation setCompletionBlockWithSuccess:newSuccess
                                                 failure:failure];
    [self.requestOperation start];
    
    
}

#pragma mark - 上传
-(void)uploadWithUrl:(id)url
              params:(NSDictionary *)params
               files:(NSArray *)files
           cachePath:(NSString* (^) (void))cacheBlock
       progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.cachePath = cacheBlock;
    //获取缓存的长度
    long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
    
    NSLog(@"＋＋＋＋＋＋＋＋cacheLength = %llu",cacheLength);
    
    //获取请求
   __strong NSMutableURLRequest* request = [[self class] requestWithUrl:url Range:cacheLength];
   
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *fileItem in files) {
            id value = [fileItem objectForKey:@"file"];        //支持四种数据类型：NSData、UIImage、NSURL、NSString
            NSString *name = [fileItem objectForKey:@"key"];            //文件字段的key
            NSString *fileName = [fileItem objectForKey:@"name"];       //文件名称
            NSString *mimeType = [fileItem objectForKey:@"type"];       //文件类型
            mimeType = mimeType ? mimeType : @"image/jpeg";
            name = name ? name : @"file";
            NSLog(@"%@",name);
            if ([value isKindOfClass:[NSData class]])
            {
                [formData appendPartWithFileData:value name:name fileName:fileName mimeType:mimeType];
            }else if ([value isKindOfClass:[UIImage class]])
            {
                
                //[formData appendPartWithFileData:UIImageJPEGRepresentation(value, 1) name:name fileName:fileName mimeType:mimeType];
                if (UIImagePNGRepresentation(value) == nil)
                {  //返回为png图像。
                    [formData appendPartWithFileData:UIImagePNGRepresentation(value) name:name fileName:fileName mimeType:mimeType];
                }else
                {   //返回为JPEG图像。
                    NSData *data =UIImageJPEGRepresentation(value, 0.5);
                    NSLog(@"------%lu",(unsigned long)data.length);
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:name fileName:fileName mimeType:mimeType];
                }
            }else if ([value isKindOfClass:[NSURL class]])
            {
                [formData appendPartWithFileURL:value name:name fileName:fileName mimeType:mimeType error:nil];
            }else if ([value isKindOfClass:[NSString class]])
            {
                [formData appendPartWithFileURL:[NSURL URLWithString:value]  name:name fileName:fileName mimeType:mimeType error:nil];
            }
        }
    } error:nil];
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.requestOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:self.cachePath() append:NO]];
    
    //处理流
    [self readCacheToOutStreamWithPath:self.cachePath()];
    
    //添加观察者，监听“暂停”
    [self.requestOperation addObserver:self forKeyPath:@"isPaused" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    //获取进度块
    self.progressBlock = progressBlock;
    
    
    //重组进度块block
    [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    
    
    //获取成功回调块
    void (^newSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseHead = %@",[operation.response allHeaderFields]);
        
        success(operation,responseObject);
    };
    
    
    [self.requestOperation setCompletionBlockWithSuccess:newSuccess
                                                 failure:failure];
    [self.requestOperation start];
    
    
    
}

#pragma mark - 获取本地缓存的字节
+(long long)cacheFileWithPath:(NSString*)path
{
    //打开一个文件准备读取
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    //读取其余的数据直到文件的末尾
    NSData* contentData = [fh readDataToEndOfFile];
    return contentData ? contentData.length : 0;
    
}


#pragma mark - 重组进度块
-(void(^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))getNewProgressBlockWithCacheLength:(long long)cachLength
{
    typeof(self)newSelf = self;
    void(^newProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        NSData* data = [NSData dataWithContentsOfFile:self.cachePath()];
        [self.requestOperation setValue:data forKey:@"responseData"];
        //        self.requestOperation.responseData = ;
        newSelf.progressBlock(bytesRead,totalBytesRead + cachLength,totalBytesExpectedToRead + cachLength);
    };
    
    return newProgressBlock;
}


#pragma mark - 读取本地缓存入流
-(void)readCacheToOutStreamWithPath:(NSString*)path
{
    //打开一个文件准备读取
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    //读取其余的数据直到文件的末尾
    NSData* currentData = [fh readDataToEndOfFile];
    
    if (currentData.length) {
        //打开流，写入data ， 未打卡查看 streamCode = NSStreamStatusNotOpen
        [self.requestOperation.outputStream open];
        
        NSInteger       bytesWritten;
        NSInteger       bytesWrittenSoFar;
        
        NSInteger  dataLength = [currentData length];
        const uint8_t * dataBytes  = [currentData bytes];
        
        bytesWrittenSoFar = 0;
        do {
            bytesWritten = [self.requestOperation.outputStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            assert(bytesWritten != 0);
            if (bytesWritten == -1) {
                break;
            } else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar != dataLength);
        
        
    }
}

#pragma mark - 获取请求

+(NSMutableURLRequest*)requestWithUrl:(id)url Range:(long long)length
{
    NSURL* requestUrl = [url isKindOfClass:[NSURL class]] ? url : [NSURL URLWithString:url];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:5*60];
    
    
    if (length) {
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",length] forHTTPHeaderField:@"Range"];
    }
    
    NSLog(@"request.head = %@",request.allHTTPHeaderFields);
    
    return request;
    
}



#pragma mark - 监听暂停
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keypath = %@ changeDic = %@",keyPath,change);
    //暂停状态
    if ([keyPath isEqualToString:@"isPaused"] && [[change objectForKey:@"new"] intValue] == 1) {
        
        
        //获取缓存的长度
        
        long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
        //暂停读取data 从文件中获取到NSNumber
        cacheLength = [[self.requestOperation.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
        NSLog(@"cacheLength = %lld",cacheLength);
        [self.requestOperation setValue:@"0" forKey:@"totalBytesRead"];
        //重组进度block
        [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    }
}


@end
