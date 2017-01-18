//
//  GoodsModel.h
//  MiningCircle
//
//  Created by ql on 2016/12/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *price;
@property (nonatomic,retain)NSString *imgUrl;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
