//
//  SwitchCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/11/2.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchDelegate <NSObject>

-(void)onClick:(id)sender;

@end
@interface SwitchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) id<SwitchDelegate> switchDelegate;
- (IBAction)switchClick:(id)sender;

@end
