//
//  ActivityView.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/10.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

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
    if (self) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return self;
}

@end
