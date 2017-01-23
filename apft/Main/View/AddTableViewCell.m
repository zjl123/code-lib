//
//  AddTableViewCell.m
//  MiningCircle
//
//  Created by ql on 15/12/9.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "AddTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation AddTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.backgroundView = nil;
    [super awakeFromNib];
    UIColor *color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = color;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    self.titleVIew.text = _info[@"title"];
    if([_info[@"title"] isEqualToString:@"项目发布"])
    {
        self.titleVIew.text = @"矿业圈头条";
    }
    
    NSString *imgUtl = _info[@"ico"];
    if([imgUtl hasPrefix:@"http"])
    {
        NSURL *url = [NSURL URLWithString:_info[@"ico"]];
        [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    }
    else
    {
        self.imgView.image = [UIImage imageNamed:_info[@"ico"]];
    }
    
   // self.redPoint.layer.cornerRadius = 4;
    
    if([_titleVIew.text isEqualToString:@"消息"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSArray *arr = [userDefault objectForKey:@"messasge"];
        if(arr.count > 0)
        {
            _redView = [[UIView alloc]initWithFrame:CGRectMake(19, 0, 8, 8)];
            _redView.backgroundColor = [UIColor redColor];
            _redView.layer.cornerRadius = 4;
            [_imgView addSubview:_redView];
        }
        else
        {
            if(_redView)
            {
                _redView.hidden = YES;
            }
        }
        
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
