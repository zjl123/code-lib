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
@interface WebViewViewController () <UIWebViewDelegate>
{
    UIButton *btn;
    UILabel *titleView;
    UIView *webBrowserView;
}
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    if ([_herfStr rangeOfString:@"?"].location != NSNotFound) {
        _herfStr = [NSString stringWithFormat:@"%@&uap=iOS",_herfStr];
    }
    else
    {
        _herfStr = [NSString stringWithFormat:@"%@?&uap=iOS",_herfStr];
    }
    
    _herfStr = [_herfStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.label removeFromSuperview];
    }
-(void)loadWeb
{
    NSURL *url = [NSURL URLWithString:self.herfStr];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    titleView.text = [web pageTitle];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if KGOLD
    [self loadWeb];
#endif
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity removeFromSuperview];
    [self.greyView removeFromSuperview];
    self.greyView = nil;
    titleView.text = [web pageTitle];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = url.absoluteString;
    if([strUrl rangeOfString:@"#callapp"].location != NSNotFound)
    {
        [webView stopLoading];
        NSArray *arr = [Tool getShareParams:strUrl];
        [self callApp:arr];
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
    }
    return YES;
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
