
//
//  BannerDetailViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/9/10.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "BannerDetailViewController.h"
#import "Login1ViewController.h"
#import "PersonCenterViewController.h"
#import "ShareView.h"
#import "Tool.h"
#import "LinkmanTableViewController.h"
#import "PwdEdite.h"
#import "DataManager.h"
#import "SearchViewController.h"
#import "ShareView.h"
#import "UIWebView+Addition.h"
#if KMIN
#import <AlipaySDK/AlipaySDK.h>
#import "IMRCChatViewController.h"
//#import <RongIMKit/RongIMKit.h>
//#import "DataSigner.h"
#endif
@interface BannerDetailViewController ()<UIAlertViewDelegate,SearchDelegate>
@end

@implementation BannerDetailViewController
{
    BOOL isHidden;
    UIButton *shareBtn;
    BOOL isRefresh;
    NSString *shareStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor redColor];
#if KMIN
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    //   shareBtn.backgroundColor = [UIColor yellowColor];
    // [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
    shareBtn.frame = CGRectMake(width1-59.5, 2, 44.5, 40);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 8.5, 2, 0);
    //  shareBtn.imageView.backgroundColor = [UIColor greenColor];
    // shareBtn.backgroundColor = [UIColor yellowColor];
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    shareBtn.hidden = YES;
    [self.navigationController.navigationBar addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
#endif
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
    // _herfStr = @"http://192.168.1.105/MiningCircle/im.do?index&uap=00";
    
    [self loadWeb];
    
    
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView.hidden == NO)
    {
        isHidden = NO;
        searchView.delegate = self;
        searchView.searchField.text = _searchStr;
    }
    else
    {
        isHidden = YES;
    }
    isRefresh = NO;
    // Do any additional setup after loading the view.
    // [self pay];
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
-(void)jumpSearch
{
    SearchViewController *searchController = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchController animated:YES];
}
-(void)loadWeb
{
    NSURL *url = [NSURL URLWithString:self.herfStr];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    self.title = _testStr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  shareBtn.hidden = NO;
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView)
    {
        searchView.hidden = isHidden;
    }
    //#if KGOLD
    if(isRefresh == YES)
    {
        [self loadWeb];
        isRefresh = NO;
    }
    //#endif
    //加字段
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    shareBtn.hidden = YES;
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
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error

{
    
    NSLog(@"加载失败，重新加载");
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
    else if ([strUrl rangeOfString:@"im=im"].location != NSNotFound)
    {
        //跳转到会话界面
        [self jumpToConversation:strUrl];
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

-(void)jumpToConversation:(NSString *)str
{
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"sssss");
    NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"&="];
    NSArray *stringArr = [str componentsSeparatedByCharactersInSet:character];
    NSString *name = stringArr.lastObject;
    NSInteger count = stringArr.count;
    NSString *userId = stringArr[count-3];
    
    
    IMRCChatViewController *conversation = [[IMRCChatViewController alloc]init];
    //通话类型改变
    conversation.title = name;
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = userId;
    [self.navigationController pushViewController:conversation animated:YES];
    
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
    else
    {
        [Tool share:arr controller:self];
    }
}

-(void)jumpUserCenter
{
    PersonCenterViewController *persenCenter = [[PersonCenterViewController alloc]init];
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    searchView.hidden = YES;
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
            SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
            searchView.hidden = YES;
            isRefresh = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
        else if (buttonIndex == 0)
        {
            UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:888];
            if(self.navigationController.viewControllers.count <=2)
            {
                btn.hidden = NO;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
#if KMIN
//支付
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
    //    [manager POST:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
    
}
#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
