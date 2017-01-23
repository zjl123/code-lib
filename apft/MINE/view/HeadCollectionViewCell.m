//
//  HeadCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "HeadCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HeadCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.logBtn setTitle:ZGS(@"login") forState:UIControlStateNormal];
    [self.logBtn setTitle:ZGS(@"login") forState:UIControlStateSelected];
    self.logBtn.layer.borderWidth = 1;
    self.logBtn.layer.masksToBounds = YES;
    self.logBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.unLogLabel.text = ZGS(@"unLog");
    self.totalAsset.text = ZGS(@"totalAsset");
    self.useableAsset.text = ZGS(@"usableAsset");
    self.profile.text = ZGS(@"lastProfile");
    NSDictionary *dict = [DEFAULT objectForKey:@"appinfo"];
    NSURL *url = [NSURL URLWithString:dict[@"ucbg"]];
    //[self.loginbg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ucbg"]];
   // [self.unLogBg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ucbg"]];
    self.unLogBg.image = [UIImage imageNamed:@"ucbg"];
    self.loginbg.image = [UIImage imageNamed:@"ucbg"];
    
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"HeadCollectionViewCell" owner:self options:nil];
        return nibArr[0];
    }
    return self;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    if(_isLogin)
    {
        [self infoView];
    }
    else
    {
        [self tip];
    }

}
-(void)setBtnInfo:(NSArray *)btnInfo
{
    _btnInfo = btnInfo;
    NSArray *arr = @[_btn1,_btn2,_btn3];
    for (int i = 0;i < arr.count;i++) {
        Horizontal *sender = arr[i];
        sender.tag = 210+i;
        NSDictionary *dict = btnInfo[i];
        sender.title = dict[@"title"];
        sender.imgStr = dict[@"ico"];
    }
    
}
-(void)tip
{
    _tipLoginView.hidden = NO;
}
-(void)infoView
{
    _tipLoginView.hidden = YES;
    self.imgView.layer.cornerRadius = 30;
    self.imgView.layer.borderWidth = 1;
    self.imgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imgView.layer.masksToBounds = YES;
    NSURL *url = [NSURL URLWithString:_info[@"userImg"]];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"test"]];
    NSString *name = [_info objectForKey:@"userName"];
    if(name.length == 0)
    {
        NSUserDefaults *userDefault = [NSUserDefaults new];
        name = [userDefault objectForKey:@"logName"];
    }
    self.name.text = name;
    CGFloat asset = [[_info objectForKey:@"totalasset"] floatValue];
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f",asset];
    NSDictionary *dict = _info[@"tbUerAccount"];
    CGFloat useable = [dict[@"availableBalance"] floatValue];
    self.useableLabel.text = [NSString stringWithFormat:@"%.2f",useable];
    
    CGFloat total = [dict[@"interestAmt"]floatValue];
    self.totalFrofile.text = [NSString stringWithFormat:@"%@%.2f",ZGS(@"totalProfile"),total];
    CGFloat yester = [_info[@"yesterdayicome"] floatValue];
    self.yProfileLabel.text = [NSString stringWithFormat:@"%.2f",yester];
}
- (IBAction)loginn:(id)sender {
 
    [self.delegate jumpLogin];
}
- (IBAction)btnclick:(Horizontal *)sender {
 //   NSLog(@"dededede");
    int tag = (int)sender.tag -210;
    NSDictionary *dict = _btnInfo[tag];
    NSString *act = dict[@"act"];
    [self.delegate headBtnJump:act];
}
@end
