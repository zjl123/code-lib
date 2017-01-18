//
//  UpDownBtn1.m
//  MiningCircle
//
//  Created by ql on 16/7/7.
//  Copyright © 2016年 zjl. All rights reserved.
//  真正的upDown，上下结构，图上文下

#import "UpDownBtn1.h"
#import "UIButton+WebCache.h"
#define MyTabButtonImageRatio 0.6
@implementation UpDownBtn1

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //图片居中
         self.imageView.contentMode=UIViewContentModeCenter;
           self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        //文字居中
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        //字体大小
        self.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        
        //文字颜色
        [self setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    }
    return self;


}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //图片居中
        self.imageView.contentMode=UIViewContentModeCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //文字居中
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        //字体大小
        self.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        
        //文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

//内部图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=contentRect.size.width;
    CGFloat imageH=contentRect.size.height*MyTabButtonImageRatio;
    
    
    return CGRectMake(0, 2, imageW, imageH);
}
//内部文字的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleY=contentRect.size.height*MyTabButtonImageRatio;
    CGFloat titleW=contentRect.size.width;
    CGFloat titleH=contentRect.size.height-titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}
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
-(void)setImg:(NSString *)img
{
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateSelected];
}
@end
