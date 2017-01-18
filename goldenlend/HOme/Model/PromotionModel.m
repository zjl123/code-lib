//
//  PromotionModel.m
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PromotionModel.h"

@implementation PromotionModel
-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self)
    {
        self.title = dict[@"tag"];
        self.detail = dict[@"tagDetail"];
    }
    return self;
}
@end
