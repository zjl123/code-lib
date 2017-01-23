//
//  ChannelCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 16/5/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ChannelCollectionViewCell.h"

@implementation ChannelCollectionViewCell

//-(void)awakeFromNib
//{
//    CGFloat w = (width1-12)/4;
//    NSLog(@"ddddddd%f",w);
//    self.layer.cornerRadius = w/2;
//    self.contentView.layer.cornerRadius = w/2;
//   // self.contentView.layer.borderWidth = 4.0f;
//    self.contentView.layer.borderColor = [[UIColor clearColor] CGColor];
//    self.contentView.layer.masksToBounds = YES;
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ChannelCollectionViewCell" owner:self options:nil];
        
        return arr[0];
    }
    return self;
}

@end
