//
//  TicketModel.h
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketModel : NSObject
@property (retain, nonatomic)NSString *title;
@property (retain, nonatomic)NSString *time;
@property (retain, nonatomic)NSString *total;
@property (retain, nonatomic)NSString *offset;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
