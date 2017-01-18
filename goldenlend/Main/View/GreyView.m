//
//  GreyView.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/9.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "GreyView.h"

@implementation GreyView

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
        self.layer.cornerRadius = 5;
      //  self.center = CGPointMake(width1/2, height1/2-80);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    }
    return self;
}
@end
