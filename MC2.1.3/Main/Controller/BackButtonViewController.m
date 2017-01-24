
//
//  BackButtonViewController.m
//  MiningCircle
//
//  Created by ql on 15/10/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "BackButtonViewController.h"
#import "UIButton+WebCache.h"
#import "BgImgButton.h"
@interface BackButtonViewController ()

@end

@implementation BackButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.topItem.title = @"";
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back"];
    [self.navigationItem setHidesBackButton:YES];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    backBtn.frame = CGRectMake(7, 4, 35, 36);
    //backBtn.frame = CGRectMake(7, 4, 30, 36);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
 //   backBtn.imageView.backgroundColor = [UIColor redColor];
  //   backBtn.backgroundColor = [UIColor greenColor];
    [backBtn addTarget:self action:@selector(leftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backBtn];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    backBtn.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    backBtn.hidden = YES;
}
-(void)leftBtnclick:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
