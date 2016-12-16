//
//  RCIMDataSource.h
//  MiningCircle
//
//  Created by ql on 2016/10/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "IMUserModel.h"
#import "IMGroupModel.h"
#define RCDataSource [RCIMDataSource shareInstance]
@interface RCIMDataSource : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMGroupUserInfoDataSource>
+(RCIMDataSource *)shareInstance;
//block传值

//- (void)MygetAllMembersOfGroup:(NSString *)groupId
//                      result:(void (^)(NSArray *userIdList))resultBlock;
/**
 *  同步群
 */
-(void)syncGroup;
/**
 *  获取所有好友(本地)
 */
-(NSArray *)getAllFriendInfo;
/**
 *  获取所有好友(服务器)
 */

-(NSArray *)refreshFriendDataby:(NSString *)userId;
/**
 *  获取所有请求好友(潜在好友)
 */
-(NSArray *)getRequestFriendInfo;
/**
 *  获取通讯录
 */
-(void)getAddressBook:(void(^)(NSDictionary *addressDict))addressBlock;
/**
 *  获取所有的群信息
 */
-(NSArray *)getAllGroupInfo;
/**
 *  根据id获取用户信息(服务器)
 */
-(void)getInfoByuserId:(NSString *)userId result:(void(^)(NSDictionary * userInfo))userBlock;
/**
 *  根据id获取用户信息(本地)
 */
-(IMUserModel *)getUserModelByUserId:(NSString *)userId;
/**
 *  根据id获取群信息(Server)
 */
-(void)getGroupInfoFromServer:(NSString *)groupId resultBlock:(void(^)(IMGroupModel * groupBlock))completion;
/**
 *  根据id获取群成员信息(本地)
 */
-(NSArray *)getAllMembersFromLocalbyGroupId:(NSString *)groupId;

@end
