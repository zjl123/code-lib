//
//  TicketModel.m
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "TicketModel.h"

@implementation TicketModel
-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self)
    {
        self.title = dict[@"title"];
        self.time = dict[@"time"];
        self.total = dict[@"total"];
        self.offset = dict[@"offSet"];
    }
    return self;
}
@end
