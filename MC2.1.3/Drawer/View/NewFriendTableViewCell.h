//
//  NewFriendTableViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserModel.h"
@protocol IMAddFriendsDelegate <NSObject>

-(void)addFriend:(UIButton *)sender andUserInfo:(IMUserModel *)model;

@end
@interface NewFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPoritial;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic)IMUserModel *model;
@property (retain, nonatomic) NSString *statues;
//@property (retain, nonatomic) NSString *userId;
@property (weak ,nonatomic) id <IMAddFriendsDelegate> addFriendDelegate;
- (IBAction)btnClick:(UIButton *)sender;

@end
