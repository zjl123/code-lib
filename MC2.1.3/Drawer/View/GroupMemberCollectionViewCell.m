//
//  GroupMemberCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GroupMemberCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation GroupMemberCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"GroupMemberCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.cornerRadius = 5.0f;
}
-(void)setModel:(IMUserModel *)model
{
    _model = model;
    self.imgView.image = nil;
    self.title.text = model.name;
    if(model.remarksName.length > 0)
    {
        self.title.text = model.remarksName;
    }
    if (model.userFriRemark.length > 0) {
        self.title.text = model.userFriRemark;
    }
    if ([_model.portraitUri hasPrefix:@"http"]||model.portraitUri == nil) {
       [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
    }
    else
    {
        self.imgView.image = [UIImage imageNamed:model.portraitUri];
    }
    
    
}
@end
