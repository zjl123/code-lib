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

-(void)setModel:(IMUserModel *)model
{
    _model = model;
    NSString *imgUrl = model.portraitUri;
    NSURL *url = [NSURL URLWithString:imgUrl];
    [self.headPortrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"contact"]];
    self.name.text = model.name;
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
