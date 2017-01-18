//
//  AppDelegate.m
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "PwdEdite.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "DataManager.h"
#import "JPUSHService.h"
#import "SDWebImageManager.h"
#import <AddressBook/AddressBook.h>
#import "Tool.h"
#import "UIImageView+WebCache.h"
#import "BannerDetailViewController.h"
#import "UMMobClick/MobClick.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AdSupport/AdSupport.h>
#import "ShowTextViewController.h"
#import "PushWebViewController.h"
//iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<UIScrollViewDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>
{
    UIButton *btnStart;
    UIPageControl *pControl;
    UIScrollView *sView;
    NSString *time;
    UINavigationController *nav;
}
@property(nonatomic,strong)UIView *lunchView;
@end

@implementation AppDelegate
@synthesize lunchView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[MobClick setLogEnabled:YES];
#if KMIN
    UMConfigInstance.appKey = @"575f7167e0f55ac335002c6f";
    UMConfigInstance.channelId = @"";
    [MobClick startWithConfigure:UMConfigInstance];
#endif
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    _myTabBar=[[MyTabBarViewController alloc]init];
    nav = [[UINavigationController alloc]initWithRootViewController:_myTabBar];
    [nav.navigationBar setBarTintColor:BLUECOLOR];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBarHidden = YES;
    _myTabBar.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:_myTabBar selector:@selector(response2:) name:@"tabbarmenu" object:nil];
    self.window.rootViewController = nav;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *lauchInfo = [NSUserDefaults new];
    if ([lauchInfo objectForKey:@"FirstLaunch1"]==nil) {
        //密码加密
        NSString *pwd = [lauchInfo objectForKey:@"password"];
        if(pwd != nil)
        {
        NSDictionary *dict = @{@"password":pwd};
        NSDictionary *entryptPwd = [PwdEdite ecoding:dict];
        [userDefault setObject:entryptPwd forKey:@"entryptPwd"];
        }
        //创建引导滚动视图
        sView = [UIScrollView new];
        sView.frame = CGRectMake(0, 0, width1, height1);
        //设置滚动内容大小
        sView.contentSize = CGSizeMake(width1*3, 0);
        //分页属性
        sView.pagingEnabled = 1;
        //反弹属性
        sView.bounces = 0;
        //隐藏水平滚动条
        sView.showsHorizontalScrollIndicator=0;
        sView.delegate = self;
        [self.window addSubview:sView];
        
        //分页控件
        pControl = [UIPageControl new];
        pControl.frame = CGRectMake(0, height1-50, width1, 30);
        pControl.numberOfPages = 3;
        pControl.pageIndicatorTintColor = [UIColor whiteColor];
        pControl.currentPageIndicatorTintColor = RGB(0, 51, 153);
        [self.window addSubview:pControl];
        
        //创建进入软件按钮
        btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStart.frame = CGRectMake(60, height1-60, width1-120, 40);
        [btnStart setTitle:ZGS(@"rightN") forState:UIControlStateNormal];
        [btnStart setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
        btnStart.layer.cornerRadius = 10;
        btnStart.layer.masksToBounds = YES;
        btnStart.titleLabel.font = [UIFont systemFontOfSize:22];
        [btnStart addTarget:self action:@selector(startApp:) forControlEvents:UIControlEventTouchUpInside];
        //默认隐藏
        [btnStart setHidden:YES];
        [self.window addSubview:btnStart];
#if KMIN
        NSArray *arr = @[@"贷",@"易",@"链"];
#elif KGOLD
        NSArray *arr = @[@"贷-1",@"易-1",@"链-1"];
#endif
        //创建4张图片视图
        for (int i=0; i<arr.count; i++) {
            UIImageView *imgView = [UIImageView new];
            imgView.frame = CGRectMake(width1*i, 0, width1, height1);
            imgView.image = [UIImage imageNamed:[arr objectAtIndex:i]];
            [sView addSubview:imgView];
        }
        
        //存储启动信息
        [lauchInfo setObject:@"YES" forKey:@"FirstLaunch1"];
    }
    //推送
    // Override point for customization after application launch.
   // NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >=10.0)
    {JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification != nil)
    {
        self.isLaunchedByNotification = YES;
    }
    
    
    //打印异常
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}
#pragma -mark 打印异常（非常好的方法）
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
-(void)removeLun
{
    [lunchView removeFromSuperview];
}

-(void)gestureLock
{
    // 手势解锁相关
    NSString* pswd = [LLLockPassword loadLockPassword];
    if (pswd) {
        [self showLLLockViewController:LLLockViewTypeCheck];
    } else {
      //  NSLog(@"dddddd");
        //        [self showLLLockViewController:LLLockViewTypeCreate];
    }

}
//页面滚动调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pControl.currentPage = scrollView.contentOffset.x/width1;
    
    if (scrollView.contentOffset.x == width1*2) {
        [btnStart setHidden:0];
        [pControl setHidden:1];
    }else
    {
        [btnStart setHidden:1];
        [pControl setHidden:0];
    }
}

-(void)startApp:(UIButton*)btn{
//NSLog(@"startApp");
    //移除滚动视图
    [sView removeFromSuperview];
    
    //获得系统应用程序
    UIApplication *application = [UIApplication sharedApplication];
    //设置系统中状态栏
    [application setStatusBarHidden:0];
    btn.hidden = YES;
    //[self.window addSubview:_rvc.view];
}

-(void)judegLogin
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger num = [userDefault integerForKey:@"autoLogin"];
    if(num == 2)
    {
        
        [self gestureLock];
        NSString *userName = [userDefault objectForKey:@"logName"];
        NSString *password = [self getPassword];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"cmd",@"ios",@"os",userName,@"username",password,@"password", nil];
        [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
                if ([resultBlock count] == 0 ||!resultBlock) {
                    [self loginfailed];
                    return;
                }
                
                int flag = [[resultBlock objectForKey:@"ret"] intValue];
                if (flag >= 0) {
                    
                    int num = 1;
                    //登录成功
                    
                    [DEFAULT setInteger:num forKey:@"login"];
                    [DEFAULT synchronize];
                    NSString *userid = [resultBlock objectForKey:@"userid"];
                    [self getMessage:userid];
                    
                }
                else
                {
                    [self loginfailed];
                }
        }];
    }
    else
    {
        [self loginfailed];
    }
}
-(NSString *)getPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSDictionary *password = [userDefault objectForKey:@"entryptPwd"];
    if(password.count > 0)
    {
        password = [PwdEdite decoding:password];
        NSString *pwd = [password objectForKey:@"password"];
        return pwd;
    }
    else
    {
        return nil;
    }
}
-(void)login
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger  num = [userDefault integerForKey:@"login"];
    if (num == 1)
    {
        NSString *userName = [userDefault objectForKey:@"logName"];
        NSString *password = [self getPassword];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"cmd",@"ios",@"os",userName,@"username",password,@"password", nil];
        
        [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
            if([resultBlock count] > 0)
            {
                int flag = [[resultBlock objectForKey:@"ret"] intValue];
                if (flag == 0) {
                    NSString *userid = [resultBlock objectForKey:@"userid"];
                    [self getMessage:userid];
                    [MobClick profileSignInWithPUID:userName];
                }
            }

        }];
    }
}

-(void)connectionServer
{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"timer",@"cmd",@"ios",@"os", nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
        
    }];
}
-(void)loginfailed
{
    //没有登录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:0 forKey:@"login"];
    [userDefault removeObjectForKey:@"usermobile"];
    [userDefault removeObjectForKey:@"entryptPwd"];
    [userDefault removeObjectForKey:@"username"];
    [userDefault removeObjectForKey:@"usercat"];
    [userDefault removeObjectForKey:@"tk"];
    [userDefault removeObjectForKey:@"IMToken"];

}

-(void)getMessage:(NSString *)userid
{
    __block NSMutableArray *message = nil;
    NSString *pathsandox = NSHomeDirectory();
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@/time.plist",pathsandox,userid];
    NSDictionary *timeDict = [[NSDictionary alloc]initWithContentsOfFile:newPath];
    NSString *postTime = timeDict[@"time"];
    if(postTime == nil)
    {
        postTime = @"0";
    }

    NSDictionary *paretemers = [[NSDictionary alloc]initWithObjectsAndKeys:@"getmsg",@"cmd",@"iOS",@"os",userid,@"userid",postTime,@"t", nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paretemers isPost:YES result:^(NSDictionary *resultBlock) {
        message = [resultBlock objectForKey:@"msglist"];
        if(message.count > 0)
        {
            NSMutableArray *mutArr = [NSMutableArray array];
            for (int i = 0; i < message.count; i++) {
                NSDictionary *dict = message[i];
                NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mutdict setObject:@"1" forKey:@"tag"];
                [mutArr addObject:mutdict];
            }
            NSUserDefaults *userDefault = [NSUserDefaults new];
            [userDefault setObject:message forKey:@"messasge"];
            time = resultBlock[@"t"];
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:mutArr];
            [thread start];
            NSString *str = @"login";
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:str,@"login",mutArr,@"msg", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:message.count];
        }
    }];
}
-(void)thread:(id)obj
{
    NSMutableArray *dataDict =  [NSMutableArray arrayWithArray:obj];
    //把图片存起来
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",pathsandox,userid];
    //写入plist文件
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@/msg.plist",pathsandox,userid];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:plistPath];
    [dataDict addObjectsFromArray:arr];
    if ([dataDict writeToFile:plistPath atomically:YES]) {
        NSLog(@"写入成功");
    };
    //写入时间
    NSDictionary *timeDict = @{@"time":time};
    NSString *timePath = [NSString stringWithFormat:@"%@/Documents/%@/time.plist",pathsandox,userid];
    if ([timeDict writeToFile:timePath atomically:YES]) {
        NSLog(@"写入成功");
        
    };
}


-(void)share
{
#if KMIN
    NSString *shareKey = @"922d4b8ad189";
    NSString *wcId = @"wx57f01daf45e1928f";
    NSString *wcSecret = @"c514cda5094a2c2cf99cda48080fa6f5";
    NSString *qqId = @"1104715219";
    NSString *qqKey = @"qOeQbcwgLZGkqDeC";
    NSString *wbKey = @"1687359612";
    NSString *wbSecret = @"f6233f09119ab2a5a493bf4f49e4750d";
#elif KGOLD
    NSString *shareKey = @"101f74dd5203c";
    NSString *wcId = @"wx404723da38fe55be";
    NSString *wcSecret = @"7f3711da2bdd9dae68b903638a2ce370";
    NSString *qqId = @"1105208298";
    NSString *qqKey = @"eAiADgyo41myy82G";
    NSString *wbKey = @"2206903889";
    NSString *wbSecret = @"78b7f7cf5543b2e65d3c248a28d6f575";
#endif
    
    
    [ShareSDK registerApp:shareKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType){
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:wbKey appSecret:wbSecret redirectUri:@"http://sns.whalecloud.com/sina2/callback" authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeTencentWeibo:
                //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
                                             appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                           redirectUri:@"http://www.sharesdk.cn"];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:wcId
                                      appSecret:wcSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:qqId
                                     appKey:qqKey
                                   authType:SSDKAuthTypeSSO];
            default:
                break;
                
                
        }
    }];
}
//9.0以下
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill,所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理，就是在这个方法出路跟callback一样的逻辑.
            NSLog(@"result111 = %@",resultDic);
        }];
    }
    return YES;
}
//9.0以上
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result222 = %@",resultDic);
            
            
            
        }];
    }

    return YES;
}
-(UIViewController *)getCurrentController
{
    UIViewController *result = nil;
    UIWindow *window = self.window;
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmp in windows) {
            if(tmp.windowLevel == UIWindowLevelNormal)
            {
                window = tmp;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return result;
}
#pragma -mark JPUSHRegisterDelegate
//iOS10 support
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
//iOS10 support
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self pushJump:userInfo];

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
-(void)pushJump:(NSDictionary *)userInfo
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if(state == UIApplicationStateInactive )
    {
        NSString *customizeField = [userInfo valueForKey:@"customUrl"];
        // NSString *content;
        if(customizeField.length > 0)
        {
            [self jumpToNotification:customizeField];
        }
        else
        {
            NSDictionary *dict = userInfo[@"aps"];
            NSString * content = dict[@"alert"];
            [self jumpToNotificationText:content];
        }
    }
    
}

//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if(state == UIApplicationStateInactive )
    {
    NSString *customizeField = [userInfo valueForKey:@"customUrl"];
   // NSString *content;
    if(customizeField.length > 0)
    {
        [self jumpToNotification:customizeField];
    }
    else
    {
        NSArray *allKeys = userInfo.allKeys;
        BOOL isRY = NO ;
        for (NSString *key in allKeys) {
            if([key isEqualToString:@"rc"])
            {
                isRY = YES;
                break;
            }
        }
                //跳转到极光
        if(!isRY)
        {
            NSDictionary *dict = userInfo[@"aps"];
            NSString * content = dict[@"alert"];
            [self jumpToNotificationText:content];
        }
        //跳转到融云
        }
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [JPUSHService registerDeviceToken:deviceToken];
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

-(void)jumpToNotificationText:(NSString *)msg
{
    ShowTextViewController *showText = [[ShowTextViewController alloc]initWithNibName:@"ShowTextViewController" bundle:nil];
    showText.msg = msg;
   [_myTabBar.currentController.navigationController pushViewController:showText animated:YES];
}
-(void)jumpToNotification:(NSString *)strUrl
{
    BannerDetailViewController *bannerDetail = [[BannerDetailViewController alloc]init];
    bannerDetail.pushHidden = YES;
    bannerDetail.herfStr = strUrl;
   [_myTabBar.currentController.navigationController pushViewController:bannerDetail animated:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // NSLog(@"555");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //查看完推送，回到后台取消掉提示红圈。
    [self login];
    [self gestureLock];
     [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[UIApplication sharedApplication]setStatusBarHidden:NO];
    static int num = 1;
    if(num == 1)
    {
        [self judegLogin];
        [self changeMenu];
        [self share];
    }
    num++;
    
    [self getRedPoint];
    
    [NSTimer scheduledTimerWithTimeInterval:840 target:self selector:@selector(connectionServer) userInfo:nil repeats:YES];
}
-(void)changeMenu
{
        //验证最后修改时间
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSString *postTime = [userDefault objectForKey:@"postTime"];
        if(postTime == nil)
        {
            postTime = @"0";
        }
    NSString *usercat = [userDefault objectForKey:@"usercat"];
    if(!usercat)
    {
        usercat = @"";
    }
#if KMIN
    NSString *tag = @"mc";

#elif KGOLD
    NSString *tag = @"gold";
#endif
    NSString *lg = [Tool getPreferredLanguage];
    if([lg isEqualToString:@"zh-Hans"])
    {
        lg = @"cn";
    }
        NSDictionary *paramers = @{@"cmd":@"getmenu",@"time":postTime,@"usercat":usercat,@"applabel":tag,@"lg":lg,@"os":@"ios"};
    
    
    
        [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
            int  tag = [resultBlock[@"ret"] intValue];
            if(tag == 0)
            {
                [[SDImageCache sharedImageCache]clearDisk];
                NSDictionary *dict = [resultBlock objectForKey:@"appinfo"];
                NSDictionary *channel = [resultBlock objectForKey:@"channel"];
                NSArray *leftMenuArr = [resultBlock objectForKey:@"leftmenu"];
                NSArray *tabbarMenuArr = [resultBlock objectForKey:@"tabmenu"];
                NSArray *userCenterArr = [resultBlock objectForKey:@"usercenter"];
                NSString *time1 = resultBlock[@"time"];
                [userDefault setObject:time1 forKey:@"postTime"];
                if(dict.count > 0)
                {
                    [userDefault setValue:dict forKey:@"appinfo"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict];
                }
                if(channel.count > 0)
                {
                    NSArray *classify = channel[@"search"];
                    NSArray *function = channel[@"function"];
                    if(classify.count > 0)
                    {
                        [userDefault setValue:classify forKey:@"searchKey"];
                    }
                    if(function.count > 0)
                    {
                        [userDefault setValue:function forKey:@"function"];
                    }
                }
                if(leftMenuArr.count > 0)
                {
                    [userDefault setValue:leftMenuArr forKey:@"LFMenu"];
                    
                }
                if(tabbarMenuArr.count > 0)
                {
                    [userDefault setValue:tabbarMenuArr forKey:@"TBMenu"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarmenu" object:tabbarMenuArr];
                }
                if(userCenterArr.count > 0)
                {
                    [userDefault setValue:userCenterArr forKey:@"UCMenu"];
                }
                
            }
            else
            {
                return ;
            }

        }];
}
-(void)getRedPoint
{
    NSDictionary *paramers = @{@"cmd":@"gethotmenu"};
    
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        NSDictionary *dict = resultBlock[@"hotmenu"];
        [DEFAULT setObject:dict forKey:@"hotmenu"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redPoint" object:dict];
    }];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
        if(self.window.rootViewController.presentingViewController == nil){
    self.lockVc = [[LLLockViewController alloc] init];
    self.lockVc.nLockViewType = type;
    
    self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:_lockVc animated:YES completion:^{
            }];
  //  NSLog(@"创建了一个pop=%@", self.lockVc);
       }
}
@end
