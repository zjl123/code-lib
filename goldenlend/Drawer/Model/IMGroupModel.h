//
//  IMGroupModel.h
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@interface IMGroupModel :RCGroup
@property (nonatomic, assign)NSInteger role;
@property (nonatomic, assign)NSInteger maxNum;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
