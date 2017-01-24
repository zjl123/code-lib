//
//  ImgCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2017/1/16.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import "ImgCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ImgCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _potrailView.layer.cornerRadius = 3.0f;
    _potrailView.layer.masksToBounds = YES;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ImgCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    _titleLabel.text = info[@"title"];
    NSURL *url = [NSURL URLWithString:info[@"detail"]];
    [_potrailView sd_setImageWithURL:url];
}
@end
