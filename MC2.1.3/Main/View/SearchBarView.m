//
//  SearchBarView.m
//  MiningCircle
//
//  Created by ql on 16/7/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = 2;
        //[RGB(200, 200, 200) colorWithAlphaComponent:0.5];
    }
    return self;
}
@end
