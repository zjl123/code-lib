//
//  MyTabBarViewController.h
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBar.h"
#import "HomeTableViewController.h"
#import "ActiveViewController.h"
#import "MyNavViewController.h"
#import "PersonCenterViewController.h"
#import "InvestViewController.h"
#import "MessageViewController.h"

@interface MyTabBarViewController : UITabBarController
@property(nonatomic,weak)MyTabBar *customTabBar;
//@property(nonatomic,strong)HomeTableViewController *home;
@property(nonatomic,strong)MyNavViewController *nv;
@property(nonatomic,strong)ActiveViewController *act;
@property(nonatomic,strong)PersonCenterViewController *pCenter;
@property(nonatomic,strong)MessageViewController *message;
@property(nonatomic,strong)InvestViewController *descover;
@property(nonatomic,strong)HomeTableViewController *home;
@property(nonatomic,strong)UIViewController *currentController;
-(void)response2:(NSNotification *)n;
@end
