//
//  ClassfiyCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ClassfiyCollectionViewCell.h"

@implementation ClassfiyCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self)
    {
        self = [super initWithFrame:frame];
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ClassfiyCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    self.titleLabel.textColor = selected ?
    [[UIColor redColor] colorWithAlphaComponent:0.8]: [[UIColor blackColor]colorWithAlphaComponent:0.8];
    self.line.backgroundColor = selected ? [UIColor clearColor] : RGB(238, 238, 238);
    self.selectedView.backgroundColor = selected ? RGB(242, 41, 41) : [UIColor clearColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
