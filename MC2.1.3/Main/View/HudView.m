//
//  HudView.m
//  MiningCircle
//
//  Created by ql on 16/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//  菊花+文字

#import "HudView.h"

@implementation HudView


//-(void)showTime:(CGFloat)time
//{
//    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(stopShow) userInfo:nil repeats:NO];
//}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HudView" owner:self options:nil];
        [self.activity startAnimating];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        return nib[0];
    }
    return self;
}
-(void)setTime:(CGFloat)time
{
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(stopShow) userInfo:nil repeats:NO];
}
-(void)stopShow
{
    [self.activity stopAnimating];
    [self removeFromSuperview];
}
-(void)startShow
{
    
    [self.activity startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
