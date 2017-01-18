//
//  ShopCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _conntactSender.layer.borderColor = RGB(225, 225, 225).CGColor;
    _conntactSender.layer.borderWidth = 1.0f;
    _conntactSender.layer.cornerRadius = 3;
    
    [_conntactSender setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    [_conntactSender setTitle:@"联系客服" forState:UIControlStateNormal];
    _storeSender.layer.borderColor = RGB(225, 225, 225).CGColor;
    _storeSender.layer.borderWidth = 1.0f;
    _storeSender.layer.cornerRadius = 3;
    [_storeSender setImage:[UIImage imageNamed:@"store"] forState:UIControlStateNormal];
    [_storeSender setTitle:@"进入店铺" forState:UIControlStateNormal];
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ShopCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}

- (IBAction)ConntactService:(id)sender {
}

- (IBAction)EnterStore:(id)sender {
}
@end
