//
//  SecendCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "SecendCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SecendCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"SecendCollectionViewCell" owner:self options:nil];
        return nibArr[0];
    }
    return self;
}
//- (void)awakeFromNib {
// //   [self drawLine];
//    //画图
//    
//}
-(void)layoutSubviews
{
    self.title.text = _dict[@"title"];
    NSURL *url = [NSURL URLWithString:_dict[@"ico"]];
    [self.imgVIew sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"gray-mc"]];
   // [self drawLine];
}
@end
