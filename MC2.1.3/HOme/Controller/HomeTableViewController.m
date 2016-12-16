//
//  HomeTableViewController.m
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//首页

#import "HomeTableViewController.h"
#import "UIImageView+WebCache.h"
#import "ImgButton.h"
#import "AppDelegate.h"
#import "GestureTableViewController.h"
#import "TableViewController.h"
#import "AboutUsViewController.h"
#import "changeMoneyPassViewController.h"
#import "FeedBackViewController.h"
#import "PersonCenterViewController.h"
#import "Tool.h"
#import "LinkmanTableViewController.h"
#import "ListCollectionViewCell.h"
#import "BgImgButton.h"
#if KMIN
#import "SVGloble.h"
#import "SVTopScrollView.h"
#import "EditChannelViewController.h"
#import "UpDownBtn.h"
#elif KGOLD
#endif
#import "PwdEdite.h"
#import "MJRefresh.h"
#import "SearchViewController.h"
#import "ImgButton.h"
#import "WebCollectionView.h"
#import "WebCollectionViewCell.h"
#import "IMRCChatViewController.h"
#define bannerHeight 128;
#define tabHeight self.tabBarController.tabBar.frame.size.height;
#define navHeight self.navigationController.navigationBar.frame.size.height;
#define validHeight height1-navHeight-tabHeight-StatuesHeight;
@interface HomeTableViewController () <UIAlertViewDelegate,jumpdelegate>

{
    NSMutableArray *mutArr;
    NSArray *functionArr;
    BOOL isChange;
    dispatch_queue_t _queue;
    dispatch_queue_t _main;
    BOOL isResponse;
}
@property(nonatomic,strong)NSMutableArray *herfArr;
#if KMIN
@property (nonatomic,strong)SVTopScrollView *topView;
@property (nonatomic,strong)WebCollectionView *rootView;
#endif
@end
@implementation HomeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    self.automaticallyAdjustsScrollViewInsets=NO;
   // NSString *path = NSHomeDirectory();
   // NSLog(@"%@",path);
    [self location];
    isResponse = NO;
#if KMIN
    web.hidden = YES;
    [self scView];
    [self setEditBtn];
    isChange = 0;
    //searchbar
    [self setUpSearchBar];
    
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if KMIN
    if(isChange)
    {
        isChange = !isChange;
        [self refreshData];
    }
#endif
    if(self.isRefresh)
    {
        [self.rootView loadData];
    }
}
#if KMIN
-(void)scView
{
    NSLog(@"<<<>>>>dddddhhhhh");
    [SVGloble shareInstance].globleWidth = width1; //屏幕宽度
    [SVGloble shareInstance].globleHeight = height1-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height-StatuesHeight-TABANOHEIGHT+12;
    //标题栏
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _main = dispatch_get_main_queue();
    dispatch_async(_queue, ^{
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSArray *arr = [userDefault objectForKey:@"function"];
        NSMutableArray *funcArr = [NSMutableArray array];
        NSMutableArray *funArr_en = [NSMutableArray array];
        for (int i = 0; i < arr.count ; i++) {
            NSDictionary *dict = arr[i];
            NSString *str = dict[@"title"];
            NSString *str_en = dict[@"title_en"];
            if(str.length > 0)
            {
                [funcArr addObject:str];
            }
            if(str_en.length > 0)
            {
                [funArr_en addObject:str_en];
            }
        }
        [userDefault setObject:funArr_en forKey:@"title_en"];
        dispatch_async(_main, ^{
            self.topView = [SVTopScrollView shareInstance];
            self.rootView = [WebCollectionView shareInstance];
            self.topView.nameArray = funcArr;
            self.rootView.funArr = arr;
            self.rootView.controller = self;
            [self.view addSubview:self.topView];
            [self.view addSubview:self.rootView];
            [self.rootView reloadData];
            [self.topView initWithNameButtons];
            __weak typeof(self)weakSelf = self;
            self.topView.IndexChangeBlock = ^(NSInteger index){
                CGPoint offset = weakSelf.rootView.contentOffset;
                offset.x = index * weakSelf.rootView.bounds.size.width;
                [weakSelf.rootView setContentOffset:offset];
            };

            //默认选择第0个
            if(funcArr.count > 0)
            {
                [self.topView setSelectedSegmentIndex:0 animated:NO];
                self.topView.IndexChangeBlock(0);
                if(isResponse)
                {
                    [self.rootView loadData];
                }
            }
            
            
        });
    });
    
}
-(void)setEditBtn
{
    
    UpDownBtn *editBtn = [[UpDownBtn alloc]init];
    editBtn.frame = CGRectMake(width1-44, 0, 44, 38);
    editBtn.tag = 891;
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSDictionary *appDict = [userDefault objectForKey:@"appinfo"];
    editBtn.imgStr = appDict[@"edit"];
    [editBtn addTarget:self  action:@selector(editChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    [editBtn setBackgroundColor:[UIColor whiteColor]];
    //阴影
    CGFloat editBtnMinx = CGRectGetMinX(editBtn.frame);
    
    UIImageView *imgVIew = [[UIImageView alloc]initWithFrame:CGRectMake(editBtnMinx-3, 0, 3, 38)];
    imgVIew.image = [UIImage imageNamed:@"bg_service_more"];
    [self.view addSubview:imgVIew];
    
    //linen
    CGFloat y = CGRectGetMaxY(editBtn.frame);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, width1, 1)];
    view.backgroundColor = RGB(220, 220, 220);
    [self.view addSubview:view];
    
}

-(void)editChannel:(UpDownBtn *)sender
{
    EditChannelViewController *editChannel = [[EditChannelViewController alloc]init];
    isChange = 1;
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView)
    {
        searchView.hidden = YES;
    }
    [self.navigationController pushViewController:editChannel animated:YES];
}
-(void)refreshData
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"function"];
    if(![self.rootView.funArr isEqualToArray:arr])
    {
        NSMutableArray *funcArr = [NSMutableArray array];
        NSMutableArray *funArr_en = [NSMutableArray array];
        for (int i = 0; i < arr.count ; i++) {
            NSDictionary *dict = arr[i];
            NSString *str = dict[@"title"];
            NSString *str_en = dict[@"title_en"];
            if(str.length > 0)
            {
                [funcArr addObject:str];
            }
            if(str_en.length > 0)
            {
                [funArr_en addObject:str_en];
            }
        }
        [userDefault setObject:funArr_en forKey:@"title_en"];
        self.topView.nameArray = funcArr;
       // self.rootView.viewNameArray = funcArr;
        self.rootView.funArr = arr;
        self.rootView.contentOffset = CGPointMake(0, 0);
        [self.topView initWithNameButtons];
       // [self.rootView initWithViews];
    }
}
#endif
-(void)setUpKuangYeYi
{
    
    NSUserDefaults *userdefault = [NSUserDefaults new];
    NSArray *arr1 = [userdefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr1[0];
    if(dict)
    {
        strUrl1  = [NSString stringWithFormat:@"%@&uap=ios",dict[@"act"]] ;
    }
}

//////大首页End//////
#pragma -mark jumpDelegate
-(void)jumpToLogin
{
//    Login1ViewController *login = [[Login1ViewController alloc]init];
//    
//    [self.navigationController pushViewController:login animated:YES];
    //父类方法
    [self gotoLogin];
}
-(void)jump:(NSString *)strUrl
{
    //父类方法
    [self jumpWebView:strUrl];
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
    // [self.navigationController pushViewController:conversation animated:YES];
    

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = url.absoluteString;
    if(strUrl.length > 0)
    {
        if([strUrl rangeOfString:@"newpage=newpage"].location != NSNotFound)
        {
            if([strUrl rangeOfString:@"prd.do?buytransfer"].location != NSNotFound||[strUrl rangeOfString:@"prd.do?info"].location != NSNotFound)
            {
                strUrl = [NSString stringWithFormat:@"%@&uap=ios",url.absoluteString];
                [webView stopLoading];
                [self jumpWebViewWithoutTitle:strUrl];
            }
            else
            {
                strUrl = [NSString stringWithFormat:@"%@&uap=ios",url.absoluteString];
                [webView stopLoading];
                [self jumpWebView:strUrl];
            }
        }
        else if([strUrl rangeOfString:@"loginui"].location != NSNotFound)
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            [alter show];
            [web stopLoading];
            [web.scrollView.mj_header endRefreshing];
        }
        else if ([strUrl rangeOfString:@"#location"].location != NSNotFound)
        {
            [self getValue];
        }
        else if ([strUrl rangeOfString:@"#about"].location !=NSNotFound)
            
        {
            self.navigationController.navigationBar.hidden = NO;
            AboutUsViewController *aboutus = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutus animated:YES];
        }
        
        else if ([strUrl rangeOfString:@"#gesture"].location !=NSNotFound)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault integerForKey:@"login"] == 0) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
                [alter show];
            }
            else
            {
                GestureTableViewController *gesture = [[GestureTableViewController alloc]init];
                gesture.title = ZGS(@"gesture");
                [self.navigationController pushViewController:gesture animated:YES];
            }
            
        }
        else if ([strUrl rangeOfString:@"#log"].location !=NSNotFound)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault integerForKey:@"login"] == 0) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
                [alter show];
            }
            else
            {
                changeMoneyPassViewController *change = [[changeMoneyPassViewController alloc]initWithNibName:@"changeMoneyPassViewController" bundle:nil];
                change.title = ZGS(@"logPwd");
                change.cmd = @"setpwd";
                [self.navigationController pushViewController:change animated:YES];
            }
            
        }
        else if ([strUrl rangeOfString:@"#funds"].location !=NSNotFound)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault integerForKey:@"login"] == 0) {
               UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
                [alter show];
            }
            else
            {
                changeMoneyPassViewController *changeMoneyPass=[[changeMoneyPassViewController alloc]initWithNibName:@"changeMoneyPassViewController" bundle:nil];
                changeMoneyPass.title = ZGS(@"fundPwd");
                changeMoneyPass.cmd = @"setmoneypwd";
                [self.navigationController pushViewController:changeMoneyPass animated:YES];
            }
            
        }
        else if ([strUrl rangeOfString:@"#feedback"].location !=NSNotFound)
        {
            FeedBackViewController *Fb = [[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
            
            [self.navigationController pushViewController:Fb animated:YES];
        }
        else if ([strUrl rangeOfString:@"#PCenter"].location != NSNotFound)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault integerForKey:@"login"] == 0) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
                [alter show];
            }
            else
            {
                PersonCenterViewController *perCenter = [[PersonCenterViewController alloc]init];
                [self.navigationController pushViewController:perCenter animated:YES];
            }
        }
        else if ([strUrl rangeOfString:@"#callapp"].location != NSNotFound)
        {
            [webView stopLoading];
            NSArray *arr =  [Tool getShareParams:strUrl];
            [self callApp:arr];
        }
    }
    return YES;
}
//- (void)getValue {
//    
//    NSMutableString *js = [NSMutableString string];
//    NSUserDefaults *userDefault = [NSUserDefaults new];
//    NSString *str = [userDefault objectForKey:@"location"];
//    [js appendString:[NSString stringWithFormat:@"fn_alertMsg('%@');", str]];
//    [web stringByEvaluatingJavaScriptFromString:js];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            static int a = 0;
         //   NSLog(@"home11111%d",a);
            a++;
            
#if KGOLD
            [self setUpKuangYeYi];
            [self refreshWeb];
#elif KMIN
            isResponse = YES;
            [self scView];
            [self refreshSearchData];
           //  NSLog(@"rrrrr<<<<<>>>>>>webbb");
#endif
            
        }
        else if ([str isEqualToString:@"login"])
        {
            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
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
         //   NSLog(@"home22222%d",a);
            a++;
#if KMIN
            UpDownBtn *uBtn = (UpDownBtn *)[self.view viewWithTag:891];
            uBtn.imgStr = dict[@"edit"];
            //logo
            BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
            lbtn.bgImg = dict[@"pull"];
            //搜索
            //加号
            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
            aBtn.bgImg = dict[@"msgico"];

#elif KGOLD
            //logo
            BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
            lbtn.bgImg = dict[@"applogol"];
            //搜索
            BgImgButton *sBtn = [self.navigationController.navigationBar viewWithTag:889];
            sBtn.bgImg = dict[@"seach"];
            //加号
            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
            aBtn.bgImg = dict[@"pull"];

#endif
        }
    }
}
@end
