//
//  RecommendCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"RecommendCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
@end
