//
//  SwitchCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/11/2.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SwitchCollectionViewCell.h"

@implementation SwitchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"SwitchCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
- (IBAction)switchClick:(id)sender {
   // if([self.switch1 respondsToSelector:@selector(onClick:)])
  //  {
        [self.switchDelegate onClick:sender];
  //  }
}
@end
