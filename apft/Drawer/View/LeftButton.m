//
//  LeftButton.m
//  MiningCircle
//
//  Created by ql on 15/10/9.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "LeftButton.h"
#define LeftButtonTitleColor  RGB(36, 159, 231)
#define LeftButtonSelectedColor  RGB(224, 66, 92)
@implementation LeftButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeLeft;

        self.titleLabel.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:LeftButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:LeftButtonSelectedColor forState:UIControlStateSelected];
        [self setTitle:@"v dsd" forState:UIControlStateNormal];
        [self setTitle:@"dcsa" forState:UIControlStateSelected];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 30;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(0, 0, imageW, imageH);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 50;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleW = 70;
    return CGRectMake(titleX, 0, titleW, titleH);
}
-(void)setHighlighted:(BOOL)highlighted{}

-(void)setImg:(NSString *)img
{
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
}
-(void)setName:(NSString *)name
{
    [self setTitle:name forState:UIControlStateNormal];
    [self setTitle:name forState:UIControlStateSelected];
}
@end
