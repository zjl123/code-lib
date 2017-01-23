//
//  DataManager.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/3.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "DataManager.h"
//#include "Encrypt.h"
//#include "base64.h"
#import "PwdEdite.h"
#import "Tool.h"
@interface DataManager ()

//@property(nonatomic,strong)NSDictionary *dic;
@end


@implementation DataManager
+(DataManager *)shareInstance
{
    static DataManager *instance = nil;
    static dispatch_once_t preciate;
    dispatch_once(&preciate, ^{
        instance = [[DataManager alloc]init];
    });
    return instance;
}
+(AFHTTPSessionManager *)shareHTTPRequestOperationManager;
{


    static AFHTTPSessionManager *manager = nil;
    if(manager == nil)
    {
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
     //   manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    return manager;
    
}
//        其中缓存协议是个枚举类型包含：
//
//        NSURLRequestUseProtocolCachePolicy（基础策略）
//
//        NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
//
//        NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
//
//        NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
//
//        NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
//
//        NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager = [AFHTTPSessionManager manager];
        //禁止自动解析
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     //   AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //    response.removesKeysWithNullValues = YES;
    //    response.readingOptions = NSJSONReadingMutableContainers;
    //    response.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    //    _manager.responseSerializer = response;
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _manager;
}
-(void)ConnectServer:(NSString *)strUrl parameters:(id)paratemers isPost:(BOOL)isPost result:(void(^)(NSDictionary * resultBlock))completion
{
    if(isPost)
    {
        if(paratemers)
        {
            paratemers = [PwdEdite ecoding:paratemers];
        }
        [self.manager POST:strUrl parameters:paratemers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            dict = [PwdEdite decoding:dict];
            //NSDictionary *dict = [PwdEdite decoding:responseObject];
            NSDictionary *newDict = [Tool replaceNull:dict];
            if(newDict.count <= 0)
            {
                completion(newDict);
            }
            completion(newDict);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil);
        }];
    }
    else
    {
        if(paratemers)
        {
            paratemers = [PwdEdite ecoding:paratemers];
        }
        [self.manager GET:strUrl parameters:paratemers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            dict = [PwdEdite decoding:dict];
           // NSDictionary *dict = [PwdEdite decoding:responseObject];
            NSDictionary *newDict = [Tool replaceNull:dict];
            if(newDict.count <= 0)
            {
                completion(newDict);
            }
            completion(newDict);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil);

        }];
            }
}
@end
