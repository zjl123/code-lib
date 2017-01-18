//
//  ActiveViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/30.
//  Copyright (c) 2015年 zjl. All rights reserved.
//
#import "ActiveViewController.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "MJRefresh.h"
#import "Login1ViewController.h"
#import "BannerDetailViewController.h"
#import "WebViewController.h"
#import "Tool.h"
#import "BgImgButton.h"
#import "IMSearchFriendViewController.h"
#import "RCDChatListCell.h"
#import "IMUserModel.h"
#import "NewFriendsViewController.h"
//#import "MNDataBaseManager.h"
#import "AddTableViewCell.h"
#import "ActSubTbVIew.h"
#import "AddressBookViewController.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import "SelectGroupMemberViewController.h"
#import "IMRCChatViewController.h"
#import "AppDelegate.h"
@interface ActiveViewController ()
{
    
    NSArray *bannerArr;
    NSMutableArray *listArr;
    NSMutableDictionary *listParamesdictParams;
    NSDictionary *dictParams;
    NSMutableDictionary *listDict;
    NSDictionary *kuangDict;
    int page;
    //弹出菜单
    ActSubTbVIew *tbView;
    //弹出菜单背景
    UIView *bgView;
    //提醒登陆
    UILabel *tipLabel ;
    UIView *tipBgView;
}
@property (nonatomic, retain) NSArray *tbArr;
@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:@"appinfo"];
    kuangDict = dict[@"kuangbar"];
    BgImgButton *sbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:888];
    
    [sbtn removeFromSuperview];
    BgImgButton *addBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
    addBtn.bgImg = kuangDict[@"ico"];
    addBtn.tag = 888;
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
    addBtn.frame = CGRectMake(width1-45, 2, 40, 40);
    [addBtn addTarget:self action:@selector(releaseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:addBtn];
    self.isRefresh = YES;
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//#if KMIN
//  //  [self refreshWeb];
//#endif
//}
-(void)releaseClick:(UIButton *)sender
{
    // NSString *str = [NSString stringWithFormat:@"%@bar.do?pubbar",MAINURL];
    NSString *str = kuangDict[@"url"];
    [self jumpWebView:str];
}
-(void)setUpKuangYeYi
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr[3];
    strUrl1 = [NSString stringWithFormat:@"%@&uap=ios",dict[@"act"]] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
