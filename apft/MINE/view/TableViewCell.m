//
//  TableViewCell.m
//  MiningCircle
//
//  Created by ql on 15/12/14.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "TableViewCell.h"
@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _redPoint.layer.cornerRadius = 4;
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
      // Configure the view for the selected state
   // _detail.numberOfLines = 0;
}
@end
