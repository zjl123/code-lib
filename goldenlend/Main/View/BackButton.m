//
//  BackButton.m
//  MiningCircle
//
//  Created by ql on 16/9/18.
//  Copyright © 2016年 zjl. All rights reserved.
// 返回按钮，框子大图片小

#import "BackButton.h"
#define imgW 30.f
@implementation BackButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
      //  self.backgroundColor = [UIColor greenColor];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w=contentRect.size.width;
    CGFloat h=contentRect.size.height;
    return CGRectMake((w-imgW)/2, (h-imgW)/2, imgW, imgW);
}
@end
