//
//  PurchaseQuantityCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/15.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PurchaseQuantityCollectionViewCell.h"

@implementation PurchaseQuantityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.moveSender setImage:[UIImage imageNamed:@"greyMove"] forState:UIControlStateNormal];
    self.inputBox.textAlignment = NSTextAlignmentCenter;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"PurchaseQuantityCollectionViewCell" owner:self options:nil];
        self.backgroundColor = [UIColor yellowColor];
       // self.inputBox.delegate = self;
        return arr[0];
    }
    return self;
}
- (IBAction)moveBtn:(UIButton *)sender {
    NSInteger num = [self.inputBox.text integerValue];
    if(num > 1)
    {
        num--;
        self.inputBox.text = [NSString stringWithFormat:@"%ld",(long)num];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"greyMove"] forState:UIControlStateNormal];
    }
}


- (IBAction)addBtn:(UIButton *)sender {
    NSInteger num = [self.inputBox.text integerValue];
    num++;
    self.inputBox.text = [NSString stringWithFormat:@"%ld",(long)num];
  //  _moveSender.imageView.image = [UIImage imageNamed:@"cartMove"];
    [_moveSender setImage:[UIImage imageNamed:@"cartMove"] forState:UIControlStateNormal];
}

@end
