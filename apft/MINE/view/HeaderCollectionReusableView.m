//
//  HeaderCollectionReusableView.m
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView ()

@end

@implementation HeaderCollectionReusableView
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _editBtn.layer.cornerRadius = 5;
}
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(self)
//    {
//        _editBtn.layer.cornerRadius = 5;
//
//    }
//    return self;
//}
- (IBAction)edit:(id)sender {
    
    [self.delegate edit:_num :sender];
}

@end
