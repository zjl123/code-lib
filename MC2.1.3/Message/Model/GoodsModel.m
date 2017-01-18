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
        double num = [dict[@"price"] doubleValue];
        if(num)
        {
        _price = [NSString stringWithFormat:@"%2.f",num];
        }
        _imgUrl = dict[@"img"];
        _goodId = dict[@"id"];
        _subTitle = dict[@"title2"];
        NSString *str = dict[@"catId"];
        if(str)
        {
            _catId = str;
        }
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"mapAttrib"]];
        NSString *img = dict[@"img"];
         if(img.length > 0)
         {
            [mutDict setObject:dict[@"img"] forKey:@"prdpic0"];
            _bannerDict = mutDict;
         }
    }
    return self;
}
@end
