//
//  Horizontal.m
//  MiningCircle
//
//  Created by ql on 15/12/9.
//  Copyright © 2015年 zjl. All rights reserved.
//  左右结构

#import "Horizontal.h"
#import "UIButton+WebCache.h"
#import "NSString+Exten.h"
@implementation Horizontal

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
      //  self.backgroundColor = [UIColor greenColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    return self;
}
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW=contentRect.size.width;
//    CGFloat imageH=contentRect.size.height;
//    return CGRectMake(imageW/6, imageH/2-12, 24, 24);
//}
//
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat W=contentRect.size.width;
//    CGFloat H=contentRect.size.height;
//    CGFloat titleH = 22;
//    return CGRectMake(W/6+24+5, (H-titleH)/2, W-(W/6+24+5)-5, titleH);
//}
//重写去掉高亮
-(void)setHighlighted:(BOOL)highlighted{}
-(void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setImgStr:(NSString *)imgStr
{
    NSURL *url = [NSURL URLWithString:imgStr];
    [self sd_setImageWithURL:url forState:UIControlStateNormal];
    [self sd_setImageWithURL:url forState:UIControlStateSelected];
}

@end
