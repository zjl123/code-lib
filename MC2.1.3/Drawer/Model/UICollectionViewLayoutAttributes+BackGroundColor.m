//
//  UICollectionViewLayoutAttributes+BackGroundColor.m
//  MiningCircle
//
//  Created by ql on 2017/1/10.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import "UICollectionViewLayoutAttributes+BackGroundColor.h"
#import <objc/runtime.h>

NSString const *bgKey = @"bgColor";
@implementation UICollectionViewLayoutAttributes (BackGroundColor)
-(void)setBgColor:(UIColor *)bgColor
{
    objc_setAssociatedObject(self, &bgKey, bgKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)bgColor
{
    return objc_getAssociatedObject(self, &bgKey);
}
@end
