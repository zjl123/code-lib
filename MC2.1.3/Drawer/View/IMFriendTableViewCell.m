//
//  IMFriendTableViewCell.m
//  MiningCircle
//
//  Created by ql on 16/10/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "IMFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RCIMDataSource.h"
@implementation IMFriendTableViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.headPortrait.clipsToBounds = YES;
    self.headPortrait.layer.cornerRadius = 3.0f;
    self.headPortrait.layer.masksToBounds = YES;
}
-(void)setModel:(IMUserModel *)model
{
    _model = model;
    NSString *imgUrl = model.portraitUri;
    NSURL *url = [NSURL URLWithString:imgUrl];
    [self.headPortrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"contact"]];
    NSString *str = model.userFriRemark;
    if(str.length <= 0)
    {
        str = model.remarksName;
        if(str.length <= 0)
        {
            str = model.name;
        }
    }
    self.name.text = str;
    if([model.phoneNum isKindOfClass:[NSNull class]])
    {
        NSLog(@"nulllll");
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
