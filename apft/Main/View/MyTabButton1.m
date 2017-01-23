
//
//  MyTabButton1.m
//  MiningCircle
//
//  Created by ql on 16/7/11.
//  Copyright © 2016年 zjl. All rights reserved.
//  不修改文字，图片的位置

#import "MyTabButton1.h"
#import "UIButton+WebCache.h"
@implementation MyTabButton1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
      //  self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
//内部图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height;
    CGFloat imageW = w;
    CGFloat imageH = h;
    
    
    return CGRectMake(0, (h-imageH)/2, imageW, imageH);
}

-(void)setItem:(UITabBarItem *)item
{
    _item=item;
    [item addObserver:self forKeyPath:@"imgStr" options:0 context:nil];
    [item addObserver:self forKeyPath:@"seleImgStr" options:0 context:nil];
     [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"imgStr"];
    [self.item removeObserver:self forKeyPath:@"seleImgStr"];
}
-(void)setHighlighted:(BOOL)highlighted{}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSURL *url = [NSURL URLWithString:self.item.imgStr];
    [self sd_setImageWithURL:url forState:UIControlStateNormal];
    NSURL *url1 = [NSURL URLWithString:self.item.seleImgStr];
    [self sd_setImageWithURL:url1 forState:UIControlStateSelected];
}
@end
