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
//#import "WebViewController.h"
#import "Tool.h"
#import "BgImgButton.h"
#import "AddTableViewCell.h"
#import "ActSubTbVIew.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import "AppDelegate.h"
@interface ActiveViewController () <UIWebViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
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
    
    UIButton *backBtn;
}
@property (nonatomic, retain) NSArray *tbArr;
@end

@implementation ActiveViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   
}
-(void)setUpKuangYeYi
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr[3];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    strUrl1 = [NSString stringWithFormat:@"%@&telid=%@&uap=ios",dict[@"act"],identifierForVendor] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
