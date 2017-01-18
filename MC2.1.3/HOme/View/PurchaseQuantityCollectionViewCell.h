//
//  PurchaseQuantityCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/12/15.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseQuantityCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detialLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputBox;
- (IBAction)moveBtn:(UIButton *)sender;

- (IBAction)addBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *moveSender;
@property (weak, nonatomic) IBOutlet UIButton *addSender;

@end
