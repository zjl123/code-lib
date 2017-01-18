//
//  NewFriendTableViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//  New Friend :1 好友，2 申请好友
//  MobileContact : 1好友 2 矿业圈用户 0通讯录好友

#import "NewFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation NewFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.headPoritial.layer.cornerRadius = 3;
    self.headPoritial.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 3;
    self.btn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStatues:(NSString *)statues
{
    _statues = statues;
    if ([statues isEqualToString:@"1"]) {
        [self acceptStatus:@"已接受" tintColor:[UIColor blackColor] andColor:[UIColor whiteColor]];
        _btn.userInteractionEnabled = NO;
    }
    else if ([statues isEqualToString:@"2"])
    {
        [self acceptStatus:@"接受" tintColor:[UIColor whiteColor] andColor:RGB(0, 122, 255)];
        _btn.userInteractionEnabled = YES;
    }
    else if ([statues isEqualToString:@"0"])
    {
        [self acceptStatus:@"邀请" tintColor:[UIColor whiteColor] andColor:RGB(0, 122, 255)];
        _btn.userInteractionEnabled = YES;
    }

}
-(void)setModel:(IMUserModel *)model
{
    _model = model;
    _name.text = model.name;
    [_headPoritial sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
    if(model.message.length > 0)
    {
        _detail.text = model.message;
    }
    if(model.phoneNum.length > 0)
    {
        _detail.text = model.phoneNum;
    }
    if ([model.status isEqualToString:@"1"]) {
        [self acceptStatus:@"已接受" tintColor:[UIColor blackColor] andColor:[UIColor whiteColor]];
        _btn.userInteractionEnabled = NO;
    }
    else if ([model.status isEqualToString:@"2"])
    {
        [self acceptStatus:@"接受" tintColor:[UIColor whiteColor] andColor:RGB(0, 122, 255)];
        _btn.userInteractionEnabled = YES;
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    [self.addFriendDelegate addFriend:sender andUserInfo:_model];
  //  [UIColor blackColor];
}
-(void)acceptStatus:(NSString *)title tintColor:(UIColor *)tintColor andColor:(UIColor *)color
{
    _btn.backgroundColor = color;
    [_btn setTitleColor:tintColor forState:UIControlStateNormal];
    [_btn setTitle:title forState:UIControlStateNormal];
   // _btn.userInteractionEnabled = NO;
}
@end
