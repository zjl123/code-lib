//
//  IMFriendTableViewCell.h
//  MiningCircle
//
//  Created by ql on 16/10/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserModel.h"
@interface IMFriendTableViewCell : UITableViewCell
@property (strong, nonatomic) IMUserModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
