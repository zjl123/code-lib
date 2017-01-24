//
//  LongHorizontal.m
//  MiningCircle
//
//  Created by ql on 2016/12/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "LongHorizontal.h"

@implementation LongHorizontal
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    return self;
}
@end
