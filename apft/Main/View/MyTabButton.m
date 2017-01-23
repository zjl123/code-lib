//
//  MyTabButton.m
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//  上下结构 tabbar上的按钮

#import "MyTabButton.h"
#import "UIButton+WebCache.h"
#import "BadgeButton.h"
#define MyTabButtonImageRatio 0.6
#define MyTabButtonTitleColor RGB(102, 102, 102)
#if KMIN
#define MyTabButtonSelectedTitleColor RGB(36, 157, 238)
#elif KGOLD
#define MyTabButtonSelectedTitleColor RGB(20, 184, 2)
#endif
@implementation MyTabButton
{
    BadgeButton *badgeBtn;
}
-(id)initWithFrame:(CGRect)frame
{
   
    self=[super initWithFrame:frame];
    if(self)
    {
        //图片居中
        self.imageView.contentMode=UIViewContentModeCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
       // self.backgroundColor = [UIColor greenColor];
        //文字居中
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        //字体大小
        self.titleLabel.font=[UIFont systemFontOfSize:11];

        //文字颜色
        [self setTitleColor:MyTabButtonTitleColor forState:UIControlStateNormal];
       //  [self setTitleColor:MyTabButtonSelectedTitleColor forState:UIControlStateSelected];
#if KMIN
        //小红点
        badgeBtn  = [[BadgeButton alloc]init];
                             //WithFrame:CGRectMake(self.frame.size.width-10, 2, 10, 10)];
        badgeBtn.frame = CGRectMake(self.frame.size.width-20, 2,9, 9);
        badgeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeBtn];
#endif
    }
    return self;
}
//内部图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height;
    CGFloat imageW = w;
    CGFloat imageH = h*MyTabButtonImageRatio;
   
    
    return CGRectMake(0, 0, imageW, imageH);
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

-(void)setItem:(UITabBarItem *)item
{
    _item=item;
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedTitleColor" options:0 context:nil];
    [item addObserver:self forKeyPath:@"titleColor" options:0 context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];

}

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"titleColor"];
}
/*
 监听到某个对象的属性改变了，就会调用
 @param keyPath 属性名
 @param object 那个对象的属性发生改变
 @param change 属性发生改变
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //设置文字
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    //NSLog(@"cccccxxx%@",self.item.titleColor);
    //颜色
    [self setTitleColor:self.item.titleColor  forState:UIControlStateSelected];
    //设置图片
    NSURL *url = [NSURL URLWithString:self.item.imgStr];
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    NSURL *url_sele = [NSURL URLWithString:self.item.seleImgStr];
    [self sd_setImageWithURL:url_sele forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    badgeBtn.badgeValue = self.item.badgeValue;
    
}

@end
