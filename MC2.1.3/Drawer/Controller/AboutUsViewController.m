//
//  AboutUsViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/12.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "AboutUsViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "UIImageView+WebCache.h"
#import "BannerDetailViewController.h"
#import "ShareView.h"
@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TipCompany;
@property (weak, nonatomic) IBOutlet UILabel *TipMail;

@property (weak, nonatomic) IBOutlet UILabel *TipTel;

@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (weak, nonatomic) IBOutlet UILabel *mailContent;

@property (weak, nonatomic) IBOutlet UILabel *companyLink;
@property (weak, nonatomic) IBOutlet UILabel *telContent;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *right;

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *currentVerson;

@end

@implementation AboutUsViewController
{
    NSDictionary *shareDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

#if KMIN
    NSString *verson = ZGS(@"currentV");
#elif KGOLD
    NSString *verson = @"当前版本1.3（Build2k1607021）";
#endif
    self.currentVerson.text = verson;

    self.title = ZGS(@"aboutus");
    self.TipCompany.text = ZGS(@"com");
    self.TipMail.text = ZGS(@"mail");
    self.TipTel.text = ZGS(@"tel");
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *appinfo = [userDefault objectForKey:@"appinfo"];
    _mailContent.text = appinfo[@"email"];
    _companyLink.text = appinfo[@"website"];
    _telContent.text = appinfo[@"tel"];
    [_QRImage sd_setImageWithURL:appinfo[@"eq"] placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    _appName.text = appinfo[@"appname"];
    _right.text = appinfo[@"copyright"];
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:appinfo[@"applogo"]] placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    self.companyLink.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.companyLink addGestureRecognizer:tap];
    self.telContent.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    [self.telContent addGestureRecognizer:tap1];
    self.mailContent.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    [self.mailContent addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3:)];
    [self.QRImage addGestureRecognizer:tap3];
    
}
-(void)tap3:(UITapGestureRecognizer *)tap
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *appinfo = [userDefault objectForKey:@"appinfo"];
    NSDictionary *qrcode = appinfo[@"qrcode"];
    if(qrcode.count > 0)
    {
        NSArray *arr = @[@"download",@{@"title":qrcode[@"name"],@"content":qrcode[@"content"],@"img":qrcode[@"ico"],@"url":qrcode[@"url"]}];
        ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        [shareView share:arr controller:self];
        [self.navigationController.view addSubview:shareView];
    }
}
-(void)tap2:(UITapGestureRecognizer *)tap
{
    NSString *strUrl = [NSString stringWithFormat:@"mailto://%@",self.mailContent.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
   // NSDictionary *dict = [NSDictionary di]
}

-(void)tap1:(UITapGestureRecognizer *)tap
{
    NSString *strUrl = [NSString stringWithFormat:@"tel://%@",self.telContent.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    NSString *strurl = self.companyLink.text;
//NSLog(@"%@",strurl);
    BannerDetailViewController *bannerDetail = [[BannerDetailViewController alloc]init];
    bannerDetail.herfStr = strurl;
    bannerDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetail animated:YES];
    
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
