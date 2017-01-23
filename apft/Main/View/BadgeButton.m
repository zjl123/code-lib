//
//  BadgeButton.m
//  MiningCircle
//
//  Created by ql on 15/10/23.
//  Copyright © 2015年 zjl. All rights reserved.
//  小红圈，带字

#import "BadgeButton.h"

@implementation BadgeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self =  [super init];
    if(self)
    {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        UIImage *img = [UIImage imageNamed:@"main_badge"];
        [img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }
    return self;
}
-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    if(badgeValue)
    {
        if([badgeValue isEqualToString:@"0"])
        {
            self.hidden = YES;
        }
        else
        {
            self.hidden = NO;
//            [self setTitle:badgeValue forState:UIControlStateNormal];
//            self.titleLabel.font = [UIFont systemFontOfSize:13];
//            //设置frame
//            CGRect frame = self.frame;
//            CGFloat badgeH = self.currentBackgroundImage.size.height;
//            CGFloat badgeW = self.currentBackgroundImage.size.width;
//            if(badgeValue.length > 1)
//            {
//                CGSize badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
//                badgeW = badgeSize.width+10;
//                badgeH +=2;
//            }
//            frame.size.width = badgeW;
//            frame.size.height = badgeH;
//            self.frame = frame;
        }
    }
    else
    {
        self.hidden = YES;
    }
}
@end
