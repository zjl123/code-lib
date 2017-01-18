//
//  DataManager.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/3.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface DataManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *manager;
+(DataManager *)shareInstance;
+(AFHTTPSessionManager *)shareHTTPRequestOperationManager;
-(void)ConnectServer:(NSString *)strUrl parameters:(id)paratemers isPost:(BOOL)isPost result:(void(^)(NSDictionary * resultBlock))completion;
@end
