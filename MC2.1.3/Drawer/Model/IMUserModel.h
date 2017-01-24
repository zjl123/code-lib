//
//  IMUserModel.h
//  MiningCircle
//
//  Created by ql on 2016/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@interface IMUserModel : RCUserInfo

/** 1 好友, 2 请求添加(黑名单) , 3  ,4 请求被拒绝 , 5 我被对方删除*/
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *updatedAt;
//我是XXX
@property (nonatomic, retain) NSString *message;
/**备注名*/
@property (nonatomic, retain) NSString *remarksName;
@property (nonatomic, retain) NSString *phoneNum;
@property (nonatomic, retain) NSString *userFriRemark;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
