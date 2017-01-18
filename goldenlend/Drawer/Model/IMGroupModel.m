//
//  IMGroupModel.m
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "IMGroupModel.h"

@implementation IMGroupModel
-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self)
    {
        self.groupId = dict[@"groupId"];
        self.portraitUri = dict[@"groupImg"];
        self.groupName = dict[@"groupName"];
        self.role = [dict[@"role"]integerValue];
    }
    return self;
}
@end
