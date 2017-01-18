//
//  AppDelegate.h
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

//#import "WWSideslipViewController.h"
#import "MyTabBarViewController.h"
#import "LLLockViewController.h"
#if KMIN
static NSString *appKey = @"979d2e432fdbc4d7906267aa";
#elif KGOLD
static NSString *appKey = @"dfbd72635a1986e14c83fc63";
#endif
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong,nonatomic)WWSideslipViewController *slide;
@property (strong,nonatomic)MyTabBarViewController *myTabBar;
//@property (strong,nonatomic)LeftTableViewController *left;
@property (nonatomic) BOOL isLaunchedByNotification;
// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;
-(void)changeMenu;
@end

