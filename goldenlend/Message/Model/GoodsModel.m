//
//  GoodsModel.m
//  MiningCircle
//
//  Created by ql on 2016/12/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self)
    {
        _title = dict[@"title"];
        _price = dict[@"price"];
        _imgUrl = dict[@"imgUrl"];
    }
    return self;
}
@end
