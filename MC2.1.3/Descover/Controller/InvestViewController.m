//
//  InvestViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/7.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "InvestViewController.h"
#import "Login1ViewController.h"
#import "BannerDetailViewController.h"
#import "Tool.h"
#import "BgImgButton.h"
@interface InvestViewController () <UIAlertViewDelegate>
@end

@implementation InvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    //self.isRefresh = YES;
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//#if KMIN
//    [self refreshWeb];
//#endif
}
-(void)setUpKuangYeYi
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr[2];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    strUrl1 = [NSString stringWithFormat:@"%@&telid=%@&uap=ios",dict[@"act"],identifierForVendor] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
