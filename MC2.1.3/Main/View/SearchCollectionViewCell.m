//
//  SearchCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 16/7/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchCollectionViewCell" owner:self options:nil];
        return [nib objectAtIndex:0];
    }
    return self;

}
@end
