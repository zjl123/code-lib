//
//  UITabBarItem+TitleColor.m
//  MiningCircle
//
//  Created by ql on 15/11/9.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "UITabBarItem+TitleColor.h"
#import <objc/runtime.h>

NSString const *titlekey = @"titleColor";
NSString const *imgKey = @"imgKey";
NSString const *seleImgKey = @"seleImgKey";
@implementation UITabBarItem (TitleColor)
-(void)setTitleColor:(UIColor *)titleColor
{
    objc_setAssociatedObject(self, &titlekey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)titleColor
{
    return objc_getAssociatedObject(self, &titlekey);
}
-(void)setImgStr:(NSString *)imgStr
{
    objc_setAssociatedObject(self, &imgKey, imgStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)imgStr
{
    return objc_getAssociatedObject(self, &imgKey);
}
-(void)setSeleImgStr:(NSString *)seleImgStr
{
    objc_setAssociatedObject(self, &seleImgKey, seleImgStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)seleImgStr
{
    return objc_getAssociatedObject(self, &seleImgKey);
}
@end
