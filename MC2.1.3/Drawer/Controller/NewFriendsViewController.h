//
//  NewFriendsViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserModel.h"
@interface NewFriendsViewController : UIViewController
//@property (nonatomic, strong) IMUserModel *model;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, retain) NSString *statues;

@property (nonatomic, strong) NSArray *keys;

@property (nonatomic, strong) NSMutableDictionary *allFriends;

@property (nonatomic, strong) NSArray *allKeys;

//@property (nonatomic, strong) NSArray *seletedUsers;
//
//@property (nonatomic, assign) BOOL hideSectionHeader;

@property (nonatomic ,assign) BOOL needSyncFriendList;
@end
