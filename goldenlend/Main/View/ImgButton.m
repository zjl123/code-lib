//
//  ImgButton.m
//  MiningCircle
//
//  Created by zhanglily on 15/9/17.
//  Copyright (c) 2015年 zjl. All rights reserved.
//  默认样式 图文

#import "ImgButton.h"
#import "UIButton+WebCache.h"
@implementation ImgButton
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{}
-(void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setNormalColor:(UIColor *)normalColor
{
    [self setTitleColor:normalColor forState:UIControlStateNormal];
}
-(void)setSelectedColor:(UIColor *)selectedColor
{
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}
-(void)setImgStr:(NSString *)imgStr
{
    NSURL *url = [NSURL URLWithString:imgStr];
    [self sd_setImageWithURL:url forState:UIControlStateNormal];
    [self sd_setImageWithURL:url forState:UIControlStateSelected];
    
}
@end
