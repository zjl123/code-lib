//
//  PromotionModel.h
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionModel : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *detail;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
