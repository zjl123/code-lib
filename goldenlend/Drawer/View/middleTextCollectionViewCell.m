//
//  middleTextCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/10/31.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "middleTextCollectionViewCell.h"

@implementation middleTextCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"middleTextCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
- (IBAction)DeleCLick:(id)sender {
    [self.logoutDelegate LogoutGroup];
}
@end
