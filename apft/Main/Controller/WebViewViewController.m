//
//  WebViewViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/12.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "WebViewViewController.h"
#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "UIWebView+Addition.h"
#import "ShareView.h"
#include "Tool.h"
#import "Login1ViewController.h"
#import "PersonCenterViewController.h"
#import "LinkmanTableViewController.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "DataManager.h"
#import <AlipaySDK/AlipaySDK.h>
@interface WebViewViewController () <UIWebViewDelegate>
{
    UIButton *btn;
    //UILabel *titleView;
    //UIView *webBrowserView;
    UIWebView *web;
    NSString *shareStr;
    UIButton *shareBtn;
    
}
@property(nonatomic, retain)GreyView *greyView;
@property(nonatomic, retain)ActivityView *activity;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.navigationController.navigationBarHidden = NO;
    // self.navigationController.navigationBar.topItem.title = @"";
    // [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // [[UIBarButtonItem appearance] setbackbu]
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-self.navigationController.navigationBar.frame.size.height-StatuesHeight)];
    web.delegate = self;
    [self.view addSubview:web];
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    searchView.hidden = YES;
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(width1-59.5, 2, 44.5, 40);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 8.5, 2, 0);
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    shareBtn.hidden = YES;
    [self.navigationController.navigationBar addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *lg = [Tool getPreferredLanguage];
    //uap必须要拼到链接尾部
    if ([_herfStr rangeOfString:@"?"].location != NSNotFound) {
        _herfStr = [NSString stringWithFormat:@"%@&lg=%@&uap=iOS",_herfStr,lg];
    }
    else
    {
        _herfStr = [NSString stringWithFormat:@"%@?&lg=%@&uap=iOS",_herfStr,lg];
    }
    _herfStr = [_herfStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self loadWeb];
    
}
-(void)loadWeb
{
    NSURL *url = [NSURL URLWithString:self.herfStr];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    //  titleView.text = [web pageTitle];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.activity removeFromSuperview];
    [self.greyView removeFromSuperview];
    self.greyView = nil;
    //  titleView.text = [web pageTitle];
}
-(void)activityStopShow
{
    //  if(view !=nil)
    //  {
    [_activity stopAnimating];
    [_greyView removeFromSuperview];
    _greyView = nil;
    //  }
}
-(void)activituStartShow
{
    if(!_greyView)
    {
        _greyView = [[GreyView alloc]init];
        _greyView.frame = CGRectMake(0, 0, 80, 80);
        _greyView.center = CGPointMake(width1/2, height1/2-80);
        [self.view addSubview:_greyView];
        _activity = [[ActivityView alloc]init];
        _activity.frame = CGRectMake(0, 0, 50, 50);
        _activity.center = _greyView.center;
        [self.view addSubview:_activity];
        [_activity startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(activityStopShow) userInfo:nil repeats:NO];
    }
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = url.absoluteString;
    
    if([strUrl rangeOfString:@"s=s"].location != NSNotFound)
    {
        shareBtn.hidden = NO;
    }
    else
    {
        shareBtn.hidden  = YES;
    }
    if([strUrl rangeOfString:@"#callapp"].location != NSNotFound)
    {
        NSArray *arr = [Tool getShareParams:strUrl];
        [self callApp:arr];
    }
    else if ([strUrl rangeOfString:@"#location"].location != NSNotFound)
    {
        [self getValue];
    }
    else
    {
        if([strUrl rangeOfString:@"loginui"].location != NSNotFound)
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            [alter show];
            alter.tag = 599;
            [web stopLoading];
        }
        else if([strUrl rangeOfString:@"call_appui=user_center"].location != NSNotFound)
        {
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }
        else if([strUrl rangeOfString:@"call_appui=back"].location != NSNotFound)
        {
            if([webView canGoBack])
            {
                [webView goBack];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            return NO;
        }
        else if ([strUrl rangeOfString:@"&bank_pay=alipay"].location != NSNotFound)
        {
            NSLog(@"paypaypay");
            [webView stopLoading];
            [self pay:strUrl];
        }
        else
        {
            shareStr = strUrl;
        }
    }
    return YES;
}
- (void)getValue {
    
    NSMutableString *js = [NSMutableString string];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *str = [userDefault objectForKey:@"location"];
    [js appendString:[NSString stringWithFormat:@"fn_alertMsg('%@');", str]];
    [web stringByEvaluatingJavaScriptFromString:js];
}

-(void)callApp:(NSArray *)arr
{
    NSString *cmd = arr[1];
    if([cmd isEqualToString:@"share"]||[cmd isEqualToString:@"weixin"])
    {
        [self share:arr
         ];
    }
    else if ([cmd isEqualToString:@"sms"])
    {
        [self sendSms:arr];
        
    }
}

-(void)jumpUserCenter
{
    PersonCenterViewController *persenCenter = [[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:persenCenter animated:YES];
}
-(void)pay:(NSString *)str

{   NSString *appScheme = @"miningcircle";
    // str = @"http://bg.miningcircle.com/MiningCircle/appproxy.do?orderDetail";
    
    AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    
    
    [manager POST:str parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@".....%@",dict);
        NSString *info = [NSString stringWithFormat:@"%@",dict[@"info"]];
        NSLog(@"%@",info);
        [[AlipaySDK defaultService] payOrder:info fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback处理支付结果】
            NSLog(@"reslutMMMMMM = %@",resultDic);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 499)
    {
        if(buttonIndex == 0)
        {
            NSURL *url = [NSURL URLWithString:self.herfStr];
            NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
            [web loadRequest:reqest];
            
        }
    }
    else if (alertView.tag == 599)
    {
        if (buttonIndex == 1) {
            Login1ViewController *login = [[Login1ViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }
        else if (buttonIndex == 0)
        {
            UIButton *btn1 = (UIButton *)[self.navigationController.navigationBar viewWithTag:888];
            if(self.navigationController.viewControllers.count <=2)
            {
                btn1.hidden = NO;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)share:(NSArray *)parames
{
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
    [shareView share:parames controller:self];
    [self.navigationController.view addSubview:shareView];
    
}
-(void)shareClick:(UIButton *)sender
{
    
    
    NSString *img = [web metaContent:@"sharePic"];
    if(img.length == 0)
    {
        img = @"shareimgae";
    }
    NSString *title = [web metaContent:@"shareTitle"];
    if(title.length == 0)
    {
        title = ZGS(@"KYQ");
    }
    NSString *content = [web metaContent:@"shareDesc"];
    if(content.length == 0)
    {
        content = [web pageTitle];
    }
    NSString *urlStr;
    if([shareStr rangeOfString:@"&uap=iOS"].location != NSNotFound)
    {
        //NSString不能改变，所以赋给一个新的NSString
        urlStr = [shareStr stringByReplacingOccurrencesOfString:@"&uap=iOS" withString:@""];
    }
    else
    {
        urlStr = shareStr;
    }
    if(urlStr.length > 0)
    {
        NSArray *arr = @[@"download",@{@"title":title,@"content":content,@"img":img,@"url":urlStr}];
        [self share:arr];
    }
}

-(void)sendSms:(NSArray *)params
{
    LinkmanTableViewController *linkman = [[LinkmanTableViewController alloc]init];
    linkman.paramsArr = params;
    NSArray *linkArr = [Tool getAddressBook];
    if(linkArr.count > 0)
    {
        linkman.linkArr = linkArr;
        [self.navigationController pushViewController:linkman animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"getFailed") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
        alertView.tag = 699;
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
