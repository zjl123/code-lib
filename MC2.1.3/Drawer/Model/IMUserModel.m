//
//  IMUserModel.m
//  MiningCircle
//
//  Created by ql on 2016/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//  单例传值

#import "IMUserModel.h"

@implementation IMUserModel

@synthesize name;
-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self)
    {
        self.userId = dict[@"userId"];
        self.portraitUri = dict[@"userImg"];
        if([self.portraitUri isMemberOfClass:[NSNull class]])
        {
            self.portraitUri = @"";
        }
        self.name = dict[@"userName"];
        self.status = dict[@"status"];
        self.message = dict[@"message"];
        self.remarksName = dict[@"nameRemark"];
        self.userFriRemark = dict[@"userFriRemark"];
        if([self.remarksName isMemberOfClass:[NSNull class]])
        {
            self.remarksName = @"";
        }
        self.phoneNum = dict[@"phoneNum"];
    }
    return self;
}
@end
