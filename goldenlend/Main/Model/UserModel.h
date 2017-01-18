//
//  UserModel.h
//  MiningCircle
//
//  Created by ql on 2016/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/** 用户名*/
@property (nonatomic,retain) NSString *userName;
/** 密码*/
@property (nonatomic,retain) NSString *pwd;
/** 用户ID*/
@property (nonatomic,retain) NSString *userID;
@end
