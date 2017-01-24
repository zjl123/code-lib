//
//  SuccessHud.m
//  MiningCircle
//
//  Created by ql on 2017/1/16.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import "SuccessHud.h"

@implementation SuccessHud

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
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SuccessHud" owner:self options:nil];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        return nib[0];
    }
    return self;
}

//-(void)setTipText:(NSString *)tipText
//{
//    self.textLabel.text = tipText;
//}
-(void)setImg:(NSString *)img
{
    self.imgView.image = [UIImage imageNamed:img];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopShow) userInfo:nil repeats:NO];
}
-(void)stopShow
{
    [self removeFromSuperview];
}

@end
