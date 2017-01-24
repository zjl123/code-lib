//
//  MyNavViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/17.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "MyNavViewController.h"
#import "AppDelegate.h"
#import "Login1ViewController.h"
#import "PersonCenterViewController.h"
#import "BadgeButton.h"
#import "UIBarButtonItem+Badge.h"
#import "UIImageView+WebCache.h"
#import "AddTableViewCell.h"
#import "Tool.h"
#import "UIButton+WebCache.h"
#import "BgImgButton.h"
#import "TableViewController.h"
#import "MsgListViewController.h"
#import "AboutUsViewController.h"
#import "PwdEdite.h"
#import "DataManager.h"
#import "BannerDetailViewController.h"
#import "UINavigationItem+TbData.h"
#import "ShareView.h"
#import "SearchView.h"
#import "LinkmanTableViewController.h"
#import "JPUSHService.h"
#import "Server.h"
@interface MyNavViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
  //  UITableView *tbView;
    UIView *bgView;
    int a;
    BgImgButton *addBtn;
    BgImgButton *searchBtn ;
    UIView *redView;
    UITapGestureRecognizer *tap;
}

@end

@implementation MyNavViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //导航栏和状态栏都变黑色
    [self.navigationBar setBarTintColor:BLUECOLOR];
    //导航栏上的字的颜色
      [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //self.navigationBar.topItem.title = @"";
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back1"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back1"];
    self.navigationBar.topItem.title = @"";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    a = 0;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bgView.hidden = YES;
}

//-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
//{
//    [self popViewControllerAnimated:YES];
//}
//nav上的加号。
-(void)setUpAdd
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:@"appinfo"];
    BgImgButton *logoBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
#if KGOLD
    //logo
    logoBtn.frame =  CGRectMake(7, 2, 88, 40);
    logoBtn.userInteractionEnabled = NO;
    NSString *imgStr = dict[@"applogol"];
#elif KMIN
    logoBtn.frame =  CGRectMake(7, 2, 40, 40);
    [logoBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *imgStr = dict[@"pull"];
#endif
    logoBtn.tag = 890;
    
    if(imgStr.length > 0)
    {
        logoBtn.bgImg = imgStr;
    }
    else
    {
#if KGOLD
        [logoBtn setImage:[UIImage imageNamed:@"logog"] forState:UIControlStateNormal];
#endif
    }
    [self.navigationBar addSubview:logoBtn];
    [self setUpPullBtn:dict];

}
-(void)setUpPullBtn:(NSDictionary*)dict
{
#if KGOLD
    NSString *imgStr = dict[@"pull"];
#elif KMIN
    NSString *imgStr = dict[@"msgico"];
#endif
    
    addBtn = [self.navigationBar viewWithTag:888];
    if(!addBtn)
    {
        addBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
        if(imgStr.length > 0)
        {
            addBtn.bgImg = imgStr;
        }
        addBtn.tag = 888;
        addBtn.frame = CGRectMake(width1-47, 2, 40, 40);
#if KGOLD
#elif KMIN
        redView = [[UIView alloc]initWithFrame:CGRectMake(40-6, 3, 6, 6)];
        redView.tag = 777;
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = 3;
        redView.hidden = YES;
        [addBtn addSubview:redView];
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSDictionary *dict = [userDefault objectForKey:@"messasge"];
        NSInteger num = [userDefault integerForKey:@"login"];

        if(dict.count > 0 && num == 1)
        {
            redView.hidden = NO;
        }
        else
        {
            redView.hidden = YES;
        }
#endif
        
        [addBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:addBtn];
    }
    else
    {
        if(imgStr.length > 0)
        {
            addBtn.bgImg = imgStr;
        }
    }
    
}
#pragma -mark rightBtnClick:
-(void)rightBtnClick:(UIButton *)btn
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
  
#if KGOLD
    [self setUpTbView:btn];
#elif KMIN
    //跳转到消息列表
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"login"] == 0) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
        alter.tag = 502;
        [alter show];
    }
    else
    {
        MsgListViewController *msgList = [[MsgListViewController alloc]initWithNibName:@"MsgListViewController" bundle:nil];
        redView.hidden = YES;
        NSDictionary *msgDict = [userDefault objectForKey:@"messasge"];
        if(msgDict.count > 0)
        {
            NSString *str = @"isLogin";
            NSDictionary *dict = @{@"login":@"login",@"msg":@[]};
           // NSInteger oldNum = [[userDefault objectForKey:@"msgcount"] integerValue];
            [userDefault setObject:@"0" forKey:@"msgcount"];
           // NSInteger aNum = [[UIApplication sharedApplication]applicationIconBadgeNumber];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:str object:dict];
            NSUserDefaults *userDefault = [NSUserDefaults new];
            [userDefault setObject:nil forKey:@"messasge"];
        }
        [self searchHidden];
        [self pushViewController:msgList animated:YES];
    }

#endif
}
-(void)leftBtnClick:(UIButton *)btn
{
    [self setUpTbView:btn];
}
-(void)setUpTbView:(UIButton *)sender
{
    if(!_tbView)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        [self.view addSubview:bgView];
#if KGOLD
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(width1*2/3-30,20+self.navigationBar.frame.size.height, width1/3+30, self.navigationItem.tbData.count*44) style:UITableViewStylePlain];
#elif KMIN
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0,20+self.navigationBar.frame.size.height, width1/3+30, self.navigationItem.tbData.count*44) style:UITableViewStylePlain];
#endif
        [bgView addSubview:_tbView];
        _tbView.scrollEnabled =  NO;
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorColor = [UIColor blackColor];
        _tbView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UINib *nib = [UINib nibWithNibName:@"AddTableViewCell" bundle:nil];
        [_tbView registerNib:nib forCellReuseIdentifier:@"add"];
        _tbView.hidden = YES;
        
    }
    sender.selected = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    [_tbView.layer addAnimation:animation forKey:@"animation"];
    [animation startProgress];
    bgView.hidden = NO;
    _tbView.hidden = NO;
    [_tbView reloadData];

    
}
-(void)tapBg:(UITapGestureRecognizer *)tapGesture
{
    tapGesture.view.hidden = YES;
  //  bgView.hidden = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    animation.subtype = kCATransitionReveal;
    [_tbView.layer addAnimation:animation forKey:@"animation"];
    _tbView.hidden = YES;
}
/*
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.childViewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(self.viewControllers.count > 1)
    {
        return YES;
    }
    else
    {
        //截获手势（解决手势冲突问题）
        if([touch.view.superview isKindOfClass:[UITableViewCell class]])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.navigationItem.tbData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add"];
    NSDictionary *dict = [self.navigationItem.tbData objectAtIndex:indexPath.row];
    cell.info = dict;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bgView.hidden = YES;
    NSDictionary *dict = self.navigationItem.tbData[indexPath.row];
    NSString *str = dict[@"act"];
    if([str isEqualToString:@"#set"])
    {
        TableViewController *setting = [[TableViewController alloc]init];
        [self searchHidden];
        [self pushViewController:setting animated:YES];
    }
    else if ([str isEqualToString:@"#msg"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            alter.tag = 502;
            [alter show];
        }
        else
        {
            MsgListViewController *msgList = [[MsgListViewController alloc]initWithNibName:@"MsgListViewController" bundle:nil];
            NSUserDefaults *userDefault = [NSUserDefaults new];
            [userDefault setObject:nil forKey:@"messasge"];
            [self searchHidden];
            [self pushViewController:msgList animated:YES];
        }
    }
    else if ([str rangeOfString:@"#callapp"].location != NSNotFound)
    {
        NSArray *arr =  [Tool getShareParams:str];

        [self callApp:arr];
    }
    else if ([str isEqualToString:@"#about"])
    {
        AboutUsViewController *aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        [self searchHidden];
        [self pushViewController:aboutus animated:YES];
    }
    else if ([str isEqualToString:@"#out"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            alter.tag = 502;
            alter.backgroundColor = [UIColor redColor];
            [alter show];
        }
        else
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"confirmLogout") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"logout"), nil];
            alter.tag = 501;
            [alter show];
        }
        
    }
    else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (![userDefault integerForKey:@"login"]) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            [alter show];
        }
        else
        {
            NSString *str = dict[@"act"];
            NSString *title = dict[@"title"];
            SearchView *search = [self.navigationController.navigationBar viewWithTag:711];
            if(search)
            {
                search.hidden = YES;
            }

            [self pushController:str title:title];
            _tbView.hidden = YES;
        }

    }

    
}
-(void)searchHidden
{
    SearchView *search = [self.navigationBar viewWithTag:711];
    if(search)
    {
        search.hidden = YES;
    }

}
-(void)callApp:(NSArray *)arr
{
    NSString *cmd = arr[1];
    if([cmd isEqualToString:@"share"]||[cmd isEqualToString:@"weixin"])
    {
        ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        [shareView share:arr controller:self];
        [self.tabBarController.view addSubview:shareView];

    }
    else if ([cmd isEqualToString:@"sms"])
    {
        [self sendSms:arr];
    }

    else
    {
        
    }
    if(addBtn.selected)
    {
        [self rightBtnClick:addBtn];
    }
}
-(void)sendSms:(NSArray *)params
{
    LinkmanTableViewController *linkman = [[LinkmanTableViewController alloc]init];
    linkman.paramsArr = params;
    [self searchHidden];
    [self pushViewController:linkman animated:YES];
}

#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
    if (alertView.tag == 501 ) {
        
        //[self loginout];
        
        [[Server shareInstance] loginout:self];
        
    }
    else
    {
        Login1ViewController *login = [[Login1ViewController alloc]init];
        [self searchHidden];
        [self pushViewController:login animated:YES];
    }
    }
    else
    {
        if(alertView.tag == 500)
        {
            Login1ViewController *login = [[Login1ViewController alloc]init];
            [self searchHidden];
            [self pushViewController:login animated:YES];
        }
    }
}
-(void)pushController:(NSString *)strurl title:(NSString *)title
{
    BannerDetailViewController *personalDetail = [[BannerDetailViewController alloc]init];
    personalDetail.herfStr = strurl;
    [self searchHidden];
    [self pushViewController:personalDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    animation.subtype = kCATransitionReveal;
    [_tbView.layer addAnimation:animation forKey:@"animation"];
    _tbView.hidden = YES;
    a--;

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    BgImgButton *sBtn = (BgImgButton*)[self.view viewWithTag:889];
    BgImgButton *lBtn = (BgImgButton*)[self.view viewWithTag:890];
    bgView.hidden = YES;
    addBtn.hidden = YES;
    sBtn.hidden = YES;
    lBtn.hidden = YES;
    a = 0;
    [super pushViewController:viewController animated:animated];
}
@end
