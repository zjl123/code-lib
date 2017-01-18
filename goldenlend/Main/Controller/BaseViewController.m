//
//  BaseViewController.m
//  MiningCircle
//
//  Created by ql on 16/1/20.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "BaseViewController.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "MJRefresh.h"
#import "BgImgButton.h"
#import "BannerDetailViewController.h"
#import "Login1ViewController.h"
#import "AppDelegate.h"
#import "Tool.h"
#import "ShareView.h"
#import "LinkmanTableViewController.h"
#import "WebViewViewController.h"
#import "SearchView.h"
#import "SearchViewController.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import <CoreLocation/CoreLocation.h>
@interface BaseViewController ()<UIWebViewDelegate,UIWebViewDelegate,UIAlertViewDelegate,SearchDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    UILabel *errorLabel;
    UIButton *reloadBtn;
    GreyView *view ;
    ActivityView *activity;
    UILabel *tipLabel ;
    UIView *tipBgView;
    SearchView *searchView;
  //  CLLocation *myLocation;

}
@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation BaseViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(response:) name:@"isLogin" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
     self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"";
    self.isRefresh = NO;
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height-StatuesHeight)];
    web.scrollView.showsVerticalScrollIndicator = NO;
    web.backgroundColor = RGB(220, 220, 220);
    web.opaque = NO;
    web.scrollView.backgroundColor = [UIColor whiteColor];
    web.delegate = self;
    [self.view addSubview:web];
    NSString *lg = [Tool getPreferredLanguage];
    strUrl1 = [NSString stringWithFormat:@"%@&lg=%@",strUrl1,lg];

    web.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUrl];
    }];
    [self setUpKuangYeYi];
    if(!web.isHidden)
    {
    [self refreshWeb];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if(web)
    {
        [web stopLoading];
        web.delegate =  nil;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    for (UIView *child in self.tabBarController.tabBar.subviews) {
        if([child isKindOfClass:[UIControl class]])
        {
            [child removeFromSuperview];
        }
    }
    
    
    BgImgButton *btn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:888];
    btn.hidden = NO;
    BgImgButton *sbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:889];
    sbtn.hidden = NO;
    BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
    lbtn.hidden = NO;
    if(searchView)
    {
        searchView.hidden = NO;
        searchView.searchField.text = @"";
        searchView.delegate = self;
        searchView.searchField.returnKeyType = UIReturnKeyDefault;
        [searchView.searchField resignFirstResponder];
    }
    
    //判断是否刷新
#if KMIN
    if(_isRefresh)
    {
        [self refreshWeb];
    }
#endif

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"isLogin" object:nil];
    BgImgButton *btn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:888];
    btn.hidden = YES;
    BgImgButton *sbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:889];
    sbtn.hidden = YES;
    BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
    lbtn.hidden = YES;
 //   [self searchHidden];

}
-(void)setUpSearchBar
{
    searchView = [[SearchView alloc]initWithFrame:CGRectMake(50, 6, width1-100, 30)];
    searchView.delegate = self;
    searchView.tag = 711;
    [self.navigationController.navigationBar addSubview:searchView];
}
-(void)refreshSearchData
{
    [searchView refreshData];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = request.URL;
    NSString *strUrl = [NSString stringWithFormat:@"%@",url];
    if([strUrl rangeOfString:@"newpage=newpage"].location != NSNotFound)
    {
            [webView stopLoading];
            [self searchHidden];
            [self jumpWebView:strUrl];
    }
    else if([strUrl rangeOfString:@"loginui"].location != NSNotFound)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
        [alter show];
        [web stopLoading];
        [web.scrollView.mj_header endRefreshing];
    }
    else if ([strUrl rangeOfString:@"#callapp"].location != NSNotFound)
    {
        [webView stopLoading];
        NSArray *arr =  [Tool getShareParams:strUrl];
        [self callApp:arr];
    }
    else if ([strUrl rangeOfString:@"#location"].location != NSNotFound)
    {
        [self getValue];
    }
    else
    {
        self.isRefresh = NO;
    }
    return YES;
}
#pragma -mark 定位
-(void)location
{
    if([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        
        _locationManager.delegate = self;
        
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //distanceFilter 是距离过滤器，为了减少对定位装置的轮询次数，位置改变不会每次都去通知委托，而是在移动了足够距离才委托通知
        //它的单位是米，这里设置至少移动1000米再通知委托处理更新。
        self.locationManager.distanceFilter = kCLDistanceFilterNone;// 如果设为kCLDistanceFilterNone，则每秒更新一次;
        [self.locationManager requestAlwaysAuthorization];//iOS8以上(必须)
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"locationtTip") delegate:nil cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
        [alert show];
    }
}
#pragma -mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *myLocation = locations[0];
    //海拔
    CGFloat al = myLocation.altitude;
    //经度
    CGFloat lo = myLocation.coordinate.longitude;
    //纬度
    CGFloat la = myLocation.coordinate.latitude;
    NSString *str = [NSString stringWithFormat:@"{\"z\":\"%f\",\"y\":\"%f\",\"x\":\"%f\"}",al,lo,la];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    [userDefault setObject:str forKey:@"location"];
    [self.locationManager stopUpdatingLocation];
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // NSLog(@"error:%@",error);
    [self stopLocation];
}
-(void)stopLocation
{
    self.locationManager = nil;
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
-(void)sendSms:(NSArray *)params
{
    LinkmanTableViewController *linkman = [[LinkmanTableViewController alloc]init];
    linkman.paramsArr = params;
    [self searchHidden];
    [self.navigationController pushViewController:linkman animated:YES];
}

-(void)share:(NSArray *)parames
{
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
    [shareView share:parames controller:self];
    [self.tabBarController.view addSubview:shareView];
}

-(void)tipLogin
{
    if(!tipBgView)
    {
        tipBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, web.frame.size.height)];
        tipBgView.backgroundColor = [RGB(250, 250, 250)colorWithAlphaComponent:0.9];
        [web addSubview:tipBgView];
        
        tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (height1-self.navigationController.navigationBar.bounds.size.height-StatuesHeight-self.tabBarController.tabBar.bounds.size.height)/2-50, width1-40, 40)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = RGB(100, 100, 100);
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.text = ZGS(@"cartLog");
        CGFloat tipLabelMaxY = CGRectGetMaxY(tipLabel.frame);
        [tipBgView addSubview:tipLabel];
        //登录按钮
        ImgButton *logBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
        logBtn.backgroundColor = MAINCOLOR;
        logBtn.layer.cornerRadius = 1;
       CGSize logSize =  [ZGS(@"gotoLog") getStringSize:[UIFont systemFontOfSize:17] width:width1];
        logBtn.frame = CGRectMake((width1-logSize.width-16)/2, tipLabelMaxY+3, logSize.width+20, 35);
        logBtn.layer.cornerRadius = 4;
        [logBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        logBtn.title = ZGS(@"gotoLog");
        logBtn.normalColor = [UIColor whiteColor];
        [tipBgView addSubview:logBtn];
    }
}
-(void)loginClick:(ImgButton *)sender
{
    [self gotoLogin];
}
-(void)setUpKuangYeYi{}
//点击跳转web
-(void)searchHidden
{
    SearchView *search = [self.navigationController.navigationBar viewWithTag:711];
    if(search)
    {
        search.hidden = YES;
    }
}
-(void)jumpWebView:(NSString *)webHref
{
    BannerDetailViewController *bannerDetail = [[BannerDetailViewController alloc]init];
    bannerDetail.herfStr = webHref;
    bannerDetail.hidesBottomBarWhenPushed = YES;
    [self searchHidden];
    [self.navigationController pushViewController:bannerDetail animated:YES];
    
}
-(void)jumpWebViewWithoutTitle:(NSString *)webHerf
{
    
    WebViewViewController *bannerDetail = [[WebViewViewController alloc]init];
    bannerDetail.herfStr = webHerf;
    bannerDetail.hidesBottomBarWhenPushed = YES;
    [self searchHidden];
    [self.navigationController pushViewController:bannerDetail animated:YES];
    
}

-(void)refreshWeb
{
    [web.scrollView.mj_header beginRefreshing];
    if(tipBgView)
    {
        [tipBgView removeFromSuperview];
        tipBgView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [web.scrollView.mj_header endRefreshing];
    _isRefresh = NO;
}
-(void)stopRefresh
{
    [web.scrollView.mj_header endRefreshing];
}
-(void)loadUrl
{
    NSURL *url = [NSURL URLWithString:strUrl1];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopRefresh) userInfo:nil repeats:NO];
}
-(void)gotoLogin
{
    Login1ViewController *login = [[Login1ViewController alloc]init];
    self.isRefresh = YES;
    [self searchHidden];
    [self.navigationController pushViewController:login animated:YES];
}
#pragma -mark SearchDelegate
-(void)jumpSearch
{
    SearchViewController *searchController = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchController animated:YES];
}
#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self gotoLogin];
    }
    else
    {
        self.isRefresh = YES;
        [self tipLogin];
    }
}


-(void)response:(NSNotification *)n
{
    
    NSDictionary *dict = [n object];
    if(dict.count > 0)
    {
    NSString *str = [dict objectForKey:@"login"];
    NSArray *msg = [dict objectForKey:@"msg"];
    if ([str isEqualToString:@"web"])
    {
//        [self setUpKuangYeYi];
//        [self refreshWeb];
    }
    else if ([str isEqualToString:@"login"])
    {
        BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
        if(!aBtn)
        {
            aBtn = [self.tabBarController.view viewWithTag:654];
        }
        UIView *redView = [aBtn viewWithTag:777];
        if(msg.count > 0)
        {
            redView.hidden = NO;
        }
        else
        {
            redView.hidden = YES;
        }
    }
    else
    {
        static int a = 0;
     //   NSLog(@"base11111%d",a);
      //  NSLog(@"CONTROLLER%@",self);
        a++;
        //logo
#if KGOLD
        BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
        lbtn.bgImg = dict[@"applogol"];
        //搜索
        BgImgButton *sBtn = [self.navigationController.navigationBar viewWithTag:889];
        sBtn.bgImg = dict[@"seach"];
        //加号
        BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
        aBtn.bgImg = dict[@"pull"];
#elif KMIN
        BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
        lbtn.bgImg = dict[@"pull"];
        //搜索
       // BgImgButton *sBtn = [self.navigationController.navigationBar viewWithTag:889];
       // sBtn.bgImg = dict[@"seach"];
        //加号
        BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
        aBtn.bgImg = dict[@"msgico"];

#endif
        
        
        
        
      //  NSUserDefaults *userDefault = [NSUserDefaults new];
//        NSInteger num = [userDefault integerForKey:@"login"];
//        if(num == 1)
//        {
//            BgImgButton *btn = (BgImgButton *)self.navigationItem.rightBarButtonItem.customView;
//            btn.bgImg = dict[@"tabbar_my_bg"];
//            
//        }
//        else
//        {
//            BgImgButton *btn = (BgImgButton *)self.navigationItem.rightBarButtonItem.customView;
//            btn.bgImg = dict[@"user_out"];
//        }

    }
    }
}
@end
