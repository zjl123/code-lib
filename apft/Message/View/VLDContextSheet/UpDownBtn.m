//
//  UpDownBtn.m
//  MiningCircle
//
//  Created by ql on 16/5/11.
//  Copyright © 2016年 zjl. All rights reserved.
// 中间一张小图（单图，改变了图的大小，已经不是上下结构了）

#import "UpDownBtn.h"
#import "UIButton+WebCache.h"
#define MyTabButtonImageRatio 0.6

@implementation UpDownBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if(self)
    {
        //图片居中
       // self.imageView.contentMode=UIViewContentModeCenter;
     //   self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.imageView.backgroundColor = [UIColor redColor];
        //文字居中
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        //字体大小
        self.titleLabel.font=[UIFont boldSystemFontOfSize:11];
        
        //文字颜色
        [self setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    }
    return self;
}
//内部图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=contentRect.size.width*MyTabButtonImageRatio;
    CGFloat imageH=contentRect.size.height*MyTabButtonImageRatio;
    return CGRectMake((contentRect.size.width-imageW)/2, (contentRect.size.height-imageH)/2, imageW, imageH);
}
////内部文字的frame
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    
//    CGFloat titleY=contentRect.size.height*MyTabButtonImageRatio;
//    CGFloat titleW=contentRect.size.width;
//    CGFloat titleH=contentRect.size.height-titleY;
//    return CGRectMake(0, titleY, titleW, titleH);
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
    //[self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
   // [self sd_setBackgroundImageWithURL:url forState:UIControlStateSelected];
    [self sd_setImageWithURL:url forState:UIControlStateNormal];
    [self sd_setImageWithURL:url forState:UIControlStateSelected];
    
}
@end
