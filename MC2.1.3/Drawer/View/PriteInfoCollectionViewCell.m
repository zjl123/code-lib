//
//  PriteInfoCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/11/3.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PriteInfoCollectionViewCell.h"

@implementation PriteInfoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"PriteInfoCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
@end
