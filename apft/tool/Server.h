//
//  Server.h
//  MiningCircle
//
//  Created by ql on 2017/1/23.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject
+(Server *)shareInstance;
/**
 * 获取站内信
 **/
-(void)getMessage:(NSString *)userid;
/**
 * 退出
 **/
-(void)loginout:(UIViewController *)vc;
@end
