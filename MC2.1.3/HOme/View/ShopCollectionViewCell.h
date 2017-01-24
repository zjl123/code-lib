//
//  ShopCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/12/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headProtrail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
- (IBAction)ConntactService:(id)sender;
- (IBAction)EnterStore:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *storeSender;

@property (weak, nonatomic) IBOutlet UIButton *conntactSender;
@end
