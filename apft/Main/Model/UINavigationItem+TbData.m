//
//  UINavigationItem+TbData.m
//  MiningCircle
//
//  Created by ql on 16/5/24.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "UINavigationItem+TbData.h"
#import <objc/runtime.h>
NSString const *tbKey = @"tbKey";
@implementation UINavigationItem (TbData)
-(void)setTbData:(NSArray *)tbData
{
    objc_setAssociatedObject(self, &tbKey, tbData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSArray *)tbData
{
    return objc_getAssociatedObject(self, &tbKey);
}
@end
