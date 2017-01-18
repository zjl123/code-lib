//
//  MyNavViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/7/17.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"
@interface MyNavViewController : UINavigationController
@property(nonatomic,retain)UIBarButtonItem *leftBtnItem;
@property(nonatomic,assign)UIImageView *imgView;
@property(nonatomic,retain)BadgeButton *badeBtn;
@property (nonatomic ,strong) UITableView *tbView;
//@property(nonatomic,retain)NSArray *menuArr;
-(void)setUpPullBtn:(NSDictionary*)dict;
-(void)setUpAdd;

@end
