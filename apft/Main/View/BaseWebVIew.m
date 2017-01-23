//
//  BaseWebVIew.m
//  MiningCircle
//
//  Created by ql on 16/5/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "BaseWebVIew.h"
#import "MJRefresh.h"
@implementation BaseWebVIew

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = RGB(220, 220, 220);
        self.opaque = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadUrl];
        }];

    }
    return self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = [NSString stringWithFormat:@"%@",url];
    if([strUrl rangeOfString:@"newpage=newpage"].location != NSNotFound)
    {
        
        [webView stopLoading];
        [self.jDelegate jump:strUrl];
        
    }
    else if ([strUrl rangeOfString:@"loginui"].location != NSNotFound)
    {
        [webView stopLoading];
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
        alter.tag = 599;
        [alter show];
    }
    return YES;
}

-(void)loadUrl
{
    NSURL *url = [NSURL URLWithString:_strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopRefresh) userInfo:nil repeats:NO];
}
-(void)stopRefresh
{
    [self.scrollView.mj_header endRefreshing];
}
#pragma -mark UIAlertViewDelegate

@end
