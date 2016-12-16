//
//  UIBarButtonItem+Badge.m
//  MiningCircle
//
//  Created by ql on 15/10/27.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "UIBarButtonItem+Badge.h"
#import <objc/runtime.h>

NSString const *badgeKey = @"badgeKey";
@implementation UIBarButtonItem (Badge)
-(void)setBadgeButton:(BadgeButton *)badgeButton
{
    objc_setAssociatedObject(self, &badgeKey, badgeButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BadgeButton *)badgeButton
{
    return objc_getAssociatedObject(self, &badgeKey);
}
@end
