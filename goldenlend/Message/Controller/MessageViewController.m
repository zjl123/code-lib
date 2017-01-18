//
//  MessageViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/27.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "MessageViewController.h"
#import "LocalBtn.h"
#import "BgImgButton.h"
@interface MessageViewController ()

@end

@implementation MessageViewController
{
    UIView *bgView ;
    UISwipeGestureRecognizer *swipRight;
    NSString *classfiyStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
  }
-(void)setUpKuangYeYi
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr[1];
    strUrl1 = [NSString stringWithFormat:@"%@&uap=ios",dict[@"act"]] ;
   // strUrl1 = @"http://192.168.1.113:8080/zheyike.html";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
