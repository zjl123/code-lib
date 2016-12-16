 //
//  MyTabBarViewController.m
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//  tabbar
#import "MyTabBarViewController.h"
#import "MyTabButton.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareView.h"
#import "BannerDetailViewController.h"
#import "Login1ViewController.h"
#import "Tool.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "UINavigationItem+TbData.h"
#import "UITabBarItem+TitleColor.h"
@interface MyTabBarViewController () <MyTabBarDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    
   // NSArray *tabbarArr;
    NSString *_statues;
    NSArray *topicArr;
    UIColor *selectedTitleColor;
    MyTabButton *tabbatBtn;
    NSMutableArray *tagArr;
    NSArray *plusArr;
    UIColor *tintColor;
    NSArray *controllerArr;
    
}
@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_statues forKey:@"statues"];
    [self setUpTabBar];
    [self setUpAllChildVc];
  //  _home.delegate = self;
}



//删除系统自动生成的UITabBarButton
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [_nv viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    for (UIView *child in self.tabBar.subviews) {
        if([child isKindOfClass:[UIControl class]])
        {
            [child removeFromSuperview];
        }
    }
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIViewController *con in controllerArr) {
        [[NSNotificationCenter defaultCenter]removeObserver:con];
    }
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
//判断tabbar是网络数据还是本地数据
#pragma -mark 设置tabbar
-(void)setUpTabBar
{
    MyTabBar *customTabBar=[[MyTabBar alloc]init];
    //tabbar的尺寸
   // customTabBar.frame=CGRectMake(0, self.tabBar.bounds.origin.y+20-StatuesHeight-12, width1, self.tabBar.bounds.size.height+12);
   // NSLog(@"TABANOHEIGHT%f",TABANOHEIGHT);
    customTabBar.frame=CGRectMake(0, self.tabBar.bounds.origin.y-TABANOHEIGHT, width1, self.tabBar.bounds.size.height+TABANOHEIGHT);
    customTabBar.backgroundColor = [UIColor clearColor];
    //找到实例化的对象
    customTabBar.delegate=self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar=customTabBar;
}
/** tabbar跳转属性*/
#pragma -mark MyTabBarDelegate
-(void)tabbar:(MyTabBar *)tabBar didSelectedButtonfrom:(int)from to:(int)to
{
    self.selectedIndex=to;
    
}

-(void)jumpDetail:(NSString *)str
{
    BannerDetailViewController *per = [[BannerDetailViewController alloc]init];
    per.herfStr = str;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController pushViewController:per animated:YES];
}

//-(void)share:(NSArray *)params
//{    
//    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
//    [shareView share:params controller:self];
//    [self.view addSubview:shareView];
//}

#pragma -mark 创建子视图
-(void)setUpAllChildVc
{
    _home=[[HomeTableViewController alloc]init];
    _message=[[MessageViewController alloc]init];
    _descover=[[InvestViewController alloc]init];
    _act=[[ActiveViewController alloc]init];
    _pCenter = [[PersonCenterViewController alloc]init];
    controllerArr = @[_home,_message,_descover,_act,_pCenter];
    NSUserDefaults *userdefault = [NSUserDefaults new];
    NSArray *arr = [userdefault objectForKey:@"TBMenu"];
    if(arr.count == 0)
    {
        NSString *str = @"http://miningcircle.com/m5/img/app/ln.png";
        NSArray *addMenuArr = @[];
        tintColor = MAINCOLOR;
        [self setUpChildVC:_home title:@"首页" image:str selectedImage:str andAddMenu:addMenuArr];
        [self setUpChildVC:_message title:@"矿业贷" image:str selectedImage:str andAddMenu:addMenuArr];
#if KGOLD
        [self setUpChildVC:_descover title:@"矿业易" image:str selectedImage:str andAddMenu:addMenuArr];
#elif KMIN
        [self setUpChildVC:_descover title:@"" image:str selectedImage:str andAddMenu:addMenuArr];
#endif
        [self setUpChildVC:_act title:@"矿业链" image:str selectedImage:str andAddMenu:addMenuArr];
        [self setUpChildVC:_pCenter title:@"我" image:str selectedImage:str andAddMenu:addMenuArr];
    }
    else
   {
        for (int i = 0; i<controllerArr.count; i++) {
            NSDictionary *dict = [arr objectAtIndex:i];
            if(i == 0)
            {
                NSString *colorStr = dict[@"tint_color"];
                if(colorStr.length > 0)
                {
                    tintColor = [Tool colorFromHexRGB:colorStr :1];
                }
            }
            NSArray *addMenuArr = dict[@"addmenu"];
            [self setUpChildVC:controllerArr[i] title:dict[@"title"] image:dict[@"ico"] selectedImage:dict[@"ico_act"] andAddMenu:addMenuArr];
            if(i == controllerArr.count -1)
            {
                _pCenter.tbArr = addMenuArr;
            }
            }
    }
}
-(void)setUpChildVC:(UIViewController *)childVc title:(NSString*)title image:(NSString *)image selectedImage:(NSString *)selectedImage andAddMenu:(NSArray *)addMenu
{
    _nv=[[MyNavViewController alloc]initWithRootViewController:childVc];
    _nv.navigationBar.translucent=NO;
    if(addMenu.count > 0)
    {
        childVc.navigationController.navigationItem.tbData = addMenu;
    }
    childVc.tabBarItem.title=title;
    childVc.tabBarItem.imgStr=image;
    childVc.tabBarItem.seleImgStr= selectedImage;
    childVc.tabBarItem.titleColor = tintColor;
 
//    [[NSNotificationCenter defaultCenter]removeObserver:childVc];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:childVc selector:@selector(response:) name:@"isLogin" object:nil];
   if(![title isEqualToString:@"我"]||![title isEqualToString:@"Me"])
    {
        //导航栏右侧按钮
        [_nv setUpAdd];
    }

    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:_nv];
    //把数据都传给tabBarItem,tabBarItem再把数据传给button
    [self.customTabBar addTabBarButtonwithItem:childVc.tabBarItem :selectedTitleColor];
}
#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        Login1ViewController *login = [[Login1ViewController alloc]init];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changeChildVC:(UIViewController *)childVc title:(NSString *)title andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage andAddMenu:(NSArray *)addMenu
{
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.imgStr = image;
    childVc.tabBarItem.seleImgStr = selectedImage;
    childVc.tabBarItem.titleColor = selectedTitleColor;
    childVc.tabBarItem.titleColor = tintColor;
    if(addMenu.count > 0)
    {
        childVc.navigationController.navigationItem.tbData = addMenu;
    }
     //[[NSNotificationCenter defaultCenter]addObserver:childVc selector:@selector(response:) name:@"isLogin" object:nil];
}

-(void)response2:(NSNotification *)n
{
    static int a = 0;
  //  NSLog(@"tab22222%d",a);
    a++;
    NSArray *tabbarArr = [n object];
  //  NSArray *controllerArr = @[_home,_message,_descover,_act,_pCenter];
    for (int i = 0; i<tabbarArr.count; i++) {

        NSDictionary *dict = [tabbarArr objectAtIndex:i];
        if(i == 0)
        {
            NSString *colorStr = dict[@"tint_color"];
            if(colorStr.length > 0)
            {
                tintColor = [Tool colorFromHexRGB:colorStr :1];
            }
        }
        NSArray *addMenuArr = dict[@"addmenu"];
        [self changeChildVC:[controllerArr objectAtIndex:i] title:[dict objectForKey:@"title"] andImage:dict[@"ico"] andSelectedImage:dict[@"ico_act"] andAddMenu:addMenuArr];
        if(i == controllerArr.count -1)
        {
            _pCenter.tbArr = addMenuArr;
        }

    }
    
    NSDictionary *dict1 = @{@"login":@"web"};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict1];
    NSLog(@"<<<<<>>>>>>webbb");
}
//-(void)response3:(NSNotification *)n
//{
//    static int a = 0;
//    NSLog(@"tab11111%d",a);
//    a++;
//    NSString *str = [n object];
//    //[NSString stringWithFormat:@"%@",[n  object]];
//    if(str.length > 0)
//    {
//        _act.tabBarItem.badgeValue = str;
//    }
//}
@end
