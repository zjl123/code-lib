//
//  WebCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 16/9/7.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "WebCollectionViewCell.h"
#import "MJRefresh.h"
#import "Tool.h"
@implementation WebCollectionViewCell
-(void)prepareForReuse
{
    [super prepareForReuse];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    [_web loadRequest:request];
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _web.scrollView.backgroundColor = [UIColor clearColor];
    _web.opaque = NO;
    _web.delegate = self;
    _web.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUrl];
    }];
}

-(void)loadUrl
{
    
    NSURL *url = [NSURL URLWithString:_strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopRefresh) userInfo:nil repeats:NO];
}
-(void)stopRefresh
{
    [_web.scrollView.mj_header endRefreshing];
}
-(void)setStrUrl:(NSString *)strUrl
{
    _strUrl = strUrl;
    NSString *lg = [Tool getPreferredLanguage];
    _strUrl = [NSString stringWithFormat:@"%@&uap=iOS&lg=%@",_strUrl,lg];
    [_web.scrollView.mj_header beginRefreshing];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = [NSString stringWithFormat:@"%@",url];
    if([strUrl rangeOfString:@"newpage=newpage"].location != NSNotFound)
    {
        
        [webView stopLoading];
        [self.jumpdelegate jump:strUrl];
        
    }
    else if ([strUrl rangeOfString:@"maidx.do?"].location != NSNotFound)
    {
        //
    }
    else if ([strUrl rangeOfString:@"loginui"].location != NSNotFound)
    {
        [webView stopLoading];
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
        alter.tag = 599;
        [alter show];
    }
    else if ([strUrl rangeOfString:@"im=im"].location != NSNotFound)
    {
        //跳转到会话界面
        [self.jumpdelegate jumpToConversation:strUrl];
       // [self jumpToConversation:strUrl];
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopRefresh];
}
#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.jumpdelegate jumpToLogin];
        
    }
}
-(void)dealloc
{
    if(_web)
    {
        [_web stopLoading];
        _web.delegate =  nil;
    }
}

@end
