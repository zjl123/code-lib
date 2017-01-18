//
//  EditChannelViewController.m
//  MiningCircle
//
//  Created by ql on 16/5/11.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "EditChannelViewController.h"
#import "MyCollectionVIew.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import "BannerDetailViewController.h"
@interface EditChannelViewController ()<jumpBanner>

@end

@implementation EditChannelViewController
{
    
    int sectionTag;
    MyCollectionVIew *myColl;
    BOOL *isSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(237, 237, 237);
    self.title = ZGS(@"MMenu");
    [self setUpSwitchBtn];
}

-(void)setUpSwitchBtn
{
    UILabel *btn = [[UILabel alloc]init];
    btn.frame = CGRectMake(10, 10, 50, 30);
    btn.text = ZGS(@"menu");
    btn.textColor = RGB(50, 50, 50);
    btn.tag = 321;
    [self.view addSubview:btn];
    UILabel *tip = [[UILabel alloc]init];
    CGSize tipSize = [ZGS(@"longDrag") getStringSize:[UIFont systemFontOfSize:14] width:width1-70];
    tip.frame = CGRectMake(width1-tipSize.width-5, 10, tipSize.width, 30);
    tip.text = ZGS(@"longDrag");
    tip.font = [UIFont systemFontOfSize:14];
    tip.textColor = RGB(150, 150, 150);
    [self.view addSubview:tip];
    //line
    CGFloat y = CGRectGetMaxY(btn.frame);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, width1, 1)];
    view.backgroundColor = RGB(237, 237, 237);
    [self.view addSubview:view];
    //collectionview
    myColl = [[MyCollectionVIew alloc]initWithFrame:CGRectMake(0, y+1, width1, height1-StatuesHeight-self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:myColl];
    myColl.jumpDelegate = self;
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"function"];
    myColl.arr = arr;
    [myColl reloadData];

}
-(void)btnCLick:(UIButton *)sender
{
    
    NSUserDefaults *userDefault = [NSUserDefaults new];
    sender.selected = YES;
    NSArray *arr = [userDefault objectForKey:@"function"];
    myColl.arr = arr;
    myColl.flag = (int)sender.tag;
    [myColl reloadData];
}
#pragma -mark jumpDelegate
-(void)jumpToBanner:(NSString *)strUrl
{
    BannerDetailViewController *bannner = [[BannerDetailViewController alloc]init];
    bannner.herfStr = strUrl;
    [self.navigationController pushViewController:bannner animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
