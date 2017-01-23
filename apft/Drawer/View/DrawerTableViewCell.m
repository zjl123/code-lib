//
//  LeftTableViewCell.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/21.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "DrawerTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation DrawerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _redPoint.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.redPoint.hidden = YES;
    // Configure the view for the selected state
}
-(void)setCellDict:(NSDictionary *)cellDict
{
    _cellDict = cellDict;
    [cellDict addObserver:self forKeyPath:@"ico" options:0 context:nil];
    [cellDict addObserver:self forKeyPath:@"title" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
 
}
-(void)setRedDict:(NSDictionary *)redDict
{
    _redDict = redDict;
    NSString *key = [NSString stringWithFormat:@"%@",_cellDict[@"id"]];
    if([[_redDict allKeys] containsObject:key])
    {
        _redPoint.hidden = NO;
    }
    else
    {
        _redPoint.hidden = YES;
    }
}
-(void)dealloc
{
    [self.cellDict removeObserver:self forKeyPath:@"ico"];
    [self.cellDict removeObserver:self forKeyPath:@"title"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSString *str = [self.cellDict objectForKey:@"ico"];
    NSURL *url = [NSURL URLWithString:str];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"a"]];
    _titleLabel.text = [self.cellDict objectForKey:@"title"];
}
@end
