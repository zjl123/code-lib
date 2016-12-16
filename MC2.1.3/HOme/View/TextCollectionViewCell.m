//
//  TextCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 16/5/23.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "TextCollectionViewCell.h"

@implementation TextCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.greyPoint.layer.cornerRadius = 2;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"TextCollectionViewCell" owner:self options:nil];
        self.title.font = [UIFont systemFontOfSize:17];
        return arr[0];
        
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.title.textColor = selected?RGB(229, 0, 68):RGB(145, 145, 145);
}

@end
