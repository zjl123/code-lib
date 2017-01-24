//
//  ClassfiyGoodsCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/9.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ClassfiyGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ClassfiyGoodsCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ClassfiyGoodsCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
-(void)setModel:(GoodsModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    if(model.price.length > 0 ||model.price)
    {
        self.priceLabel.hidden = NO;
        self.priceLabel.text = model.price;
    }
    else
    {
        self.priceLabel.hidden = YES;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"gray-mc"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
