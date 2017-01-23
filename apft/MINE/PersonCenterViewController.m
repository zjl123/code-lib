//
//  PersonCenterViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/19.
//  Copyright (c) 2015年 zjl. All rights reserved.
//
#import "PersonCenterViewController.h"
#import "HeadDetailViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#define MENU_NUM 5
#import "AppDelegate.h"
#import "MsgListViewController.h"
#import "BadgeButton.h"
#import "BannerDetailViewController.h"
//new collection
#import "FunctionCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HeadCollectionViewCell.h"
//#import "SecendCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "AddTableViewCell.h"
#import "Login1ViewController.h"
#import "TableViewController.h"
#import "AboutUsViewController.h"
#import "UIImage+Extension.h"
#import "MyNavViewController.h"
#import "BgImgButton.h"
#import "UINavigationItem+TbData.h"
#import "NSString+Exten.h"
#define GOLDNAVCOLOR(a) [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:(a)]
#define HEADHEIGHT 200
@interface PersonCenterViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,LogDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *dataDcit;
    NSArray *sectionArr;
    NSArray *pullArr;
  //  int mMenuShowStatus;/*bit0:menu1,bit1:menu2,,,*/
    NSArray *cellTitle;
    UICollectionView *collView;
    float totalMy;
    UIImageView *badgeButton ;
    NSArray *secendArr;
    NSDictionary *redDict;
    BgImgButton *addBtn;
    UITableView *tbView;
    UIView *redView;
    int a;
    int lll;
    UIView *bgView;
    BgImgButton *logoBtn;
    UILabel *unLoglabel;
    NSTimer *timer;
   // UITapGestureRecognizer *unLogViewTap;
}
//未登录时的遮罩层
@property(nonatomic,retain)UIView *unLogView;
@end

@implementation PersonCenterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [web removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
    MyNavViewController *nv = (MyNavViewController *)self.navigationController;
    [nv.navigationBar setBarTintColor:[UIColor blackColor]];
 //   nv.navigationBar.translucent=YES;
    
    BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
    
    if(aBtn)
    {
        [aBtn removeFromSuperview];
    }
    
    BgImgButton *bBtn = [self.navigationController.navigationBar viewWithTag:890];
    if(bBtn)
    {
        [bBtn removeFromSuperview];
    }
    [self setUpAdd];
    tbView = nil;
    self.isRefresh = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat y = collView.contentOffset.y;
    
    if(y<= 50)
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    else
    {
        self.navigationController.navigationBar.alpha = 1.0f;
       // [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationController.navigationBar.translucent = YES;
        
        
        
    }
    addBtn.hidden = NO;
    logoBtn.hidden = NO;
    NSUserDefaults *userdefault = [NSUserDefaults new];
    NSInteger num = [userdefault integerForKey:@"login"];
    if(num == 1)
    {
        _isLog = YES;
        self.unLogView.hidden = YES;
        collView.scrollEnabled = YES;
    }
    else
    {
        _isLog = NO;
        self.unLogView.hidden = NO;
        [collView setContentOffset:CGPointMake(0, 0)];
        collView.scrollEnabled = NO;
    }
    
//每次都要走的
    if(collView.numberOfSections > 0)
    {
        if(_isLog)
        {
            dataDcit = nil;
            [self loadData];
        }
        else
        {
            [collView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
        }
    }
    
    a = 0;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //nav的设置
    CGFloat y = collView.contentOffset.y;
    if(y <= 50)
    {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];

        [self.navigationController.navigationBar setBackgroundImage:[UIImage imagewithColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:0]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage imagewithColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:0]];
        self.navigationController.navigationBar.alpha = 0;
    }
//    self.navigationController.navigationBar.translucent = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    a = 0;
    addBtn.hidden = YES;
    logoBtn.hidden = YES;
    bgView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController.navigationBar setBarTintColor:BLUECOLOR];
    self.navigationController.navigationBar.translucent = NO;

}
#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if(y <= 0)
    {
        self.navigationController.navigationBar.alpha = 0;
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;

        if(y/200 >= 1)
        {
            return;
        }
        self.navigationController.navigationBar.alpha = y/222;
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y+StatuesHeight+self.navigationController.navigationBar.frame.size.height;
    if(y < HEADHEIGHT*2/3)
    {
        // collView setcont
        [collView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(y <= HEADHEIGHT)
    {
        self.navigationController.navigationBar.alpha  = 1.0f;
    }
    else
    {
        self.navigationController.navigationBar.alpha = 1.0f;
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat y = scrollView.contentOffset.y+StatuesHeight+self.navigationController.navigationBar.frame.size.height;
    if(y < HEADHEIGHT*2/3)
    {
        // collView setcont
        [collView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(y <= HEADHEIGHT)
    {
        [collView setContentOffset:CGPointMake(0, 200-StatuesHeight-self.navigationController.navigationBar.frame.size.height) animated:YES];
        self.navigationController.navigationBar.alpha  = 1.0f;
    }
    else
    {
        self.navigationController.navigationBar.alpha = 1.0f;
    }
}
#pragma -mark loggedinView
-(void)setUpKuangYeYi
{
     web.hidden = YES;
   // NSLog(@"PCCCPCCC");
    NSUserDefaults *userDefault = [NSUserDefaults new];
    //创建网格
    //创建网格布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    collView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-self.tabBarController.tabBar.frame.size.height) collectionViewLayout:flowLayout];
    collView.delegate = self;
    collView.dataSource = self;
    [self.view addSubview:collView];
    collView.backgroundColor = RGB(237, 237, 237);
    collView.showsVerticalScrollIndicator = NO;
    sectionArr = [userDefault objectForKey:@"UCMenu"];
    pullArr = [userDefault objectForKey:@"LFMenu"];
    NSDictionary *dict = [sectionArr objectAtIndex:0];
    secendArr = [dict objectForKey:@"item"];
    //collectionViewCell注册
    [collView registerClass:[HeadCollectionViewCell class] forCellWithReuseIdentifier:@"chead"];
   // [collView registerClass:[SecendCollectionViewCell class] forCellWithReuseIdentifier:@"csecend"];
    [collView registerClass:[FunctionCollectionViewCell class] forCellWithReuseIdentifier:@"ewq"];
    [collView registerClass:[FunctionCollectionViewCell class] forCellWithReuseIdentifier:@"qwe"];
     [collView registerClass:[FunctionCollectionViewCell class] forCellWithReuseIdentifier:@"kkk"];
    UINib *nib = [UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil];
    [collView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    redDict = [userDefault objectForKey:@"hotmenu"];
}
-(void)loginClick:(UIButton *)btn
{
    [self changeLogin];
}
#pragma -mark UIAlertVIewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if((alertView.tag == 502&&buttonIndex == 1)||(alertView.tag == 500&&buttonIndex == 0))
    {
      
        [self changeLogin];
    }
    if(alertView.tag == 501&&buttonIndex == 1)
    {
        [self loginout];
    }
    
}
#pragma loginout
-(void)loginout
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *paramers = [[NSDictionary alloc]initWithObjectsAndKeys:@"logout",@"cmd",nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            if([resultBlock count] > 0 && [[resultBlock objectForKey:@"ret"] intValue] == 0)
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"logoutSuc") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                [av show];
                av.delegate = self;
                av.tag = 500;
                NSString *str = @"0";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cart" object:str];
                [userDefault setInteger:3 forKey:@"autoLogin"];
                [userDefault setInteger:0 forKey:@"login"];
                [userDefault removeObjectForKey:@"entryptPwd"];
                [userDefault removeObjectForKey:@"username"];
                [userDefault removeObjectForKey:@"usercat"];
                [userDefault removeObjectForKey:@"tk"];
                [userDefault removeObjectForKey:@"IMToken"];
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"login",@[],@"msg", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
            }
            else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"logoutAgain") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                av.tag = 505;
                [av show];
            }

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"exception") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
            [alert show];
        }
    }];
}

#pragma -mark login
-(void)changeLogin
{
    Login1ViewController *login = [[Login1ViewController alloc]initWithNibName:@"Login1ViewController" bundle:nil];
    self.isRefresh = YES;
    [self.navigationController pushViewController:login animated:YES];
}
#pragma -mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        NSDictionary *dict = sectionArr[section];
        NSArray *arr = dict[@"item"];
        NSInteger num = arr.count;
        if(num%2 != 0)
        {
            num+=1;
        }
        return num;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sectionArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chead" forIndexPath:indexPath];
        cell.isLogin = _isLog;
        cell.delegate = self;
        if(dataDcit.count > 0)
        {
            cell.info = dataDcit;
        }
         cell.btnInfo = secendArr;
        //[cell setNeedsLayout];

        return cell;
    }
    else
    {
        NSDictionary *dict = sectionArr[indexPath.section];
        NSArray *arr = dict[@"item"];
        if(indexPath.row < arr.count)
        {
            NSDictionary *infoDict = arr[indexPath.row];
            NSString *bgColor = infoDict[@"label3"];
            if(bgColor.length > 0)
            {
                FunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ewq" forIndexPath:indexPath];
                
                cell.dict = infoDict;
                cell.redDict = redDict;
                 return cell;
            }
            else
            {
                FunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qwe" forIndexPath:indexPath];
                cell.dict =  infoDict;
                cell.redDict = redDict;
                return cell;
                
            }
        }
        else
        {
            FunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kkk" forIndexPath:indexPath];
            cell.titleName.text = @"";
            cell.subTitle.text = @"";
            cell.redPoint.hidden = YES;
            cell.icon = nil;
            return cell;

        }
    
    }

}
#pragma -mark UICollectionVIewDelegate
//网格的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return CGSizeMake(width1, HEADHEIGHT);
    }
    else
    {
        return CGSizeMake(width1/2-0.5, 70);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
        return CGSizeMake(width1, 35);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.editBtn.hidden = YES;
    NSDictionary *dict = [sectionArr objectAtIndex:indexPath.section];
    view.title.text = dict[@"title"];
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isLog)
    {
    if(indexPath.section == 0)
    {
        if(indexPath.row != 0)
        {
            NSDictionary *dict = secendArr[indexPath.row-1];
            NSString *str = dict[@"act"];
           [self jumpDetail:str];
        }
        else
        {
            HeadDetailViewController *headDetail = [[HeadDetailViewController alloc]initWithNibName:@"HeadDetailViewController" bundle:nil];
            headDetail.name = dataDcit[@"userName"];
            headDetail.imgUrl = dataDcit[@"userImg"];
            [self.navigationController pushViewController:headDetail animated:YES];
        
        }
    }
    else
    {
            NSDictionary *dict = sectionArr[indexPath.section];
            NSArray *arr = dict[@"item"];
            if(indexPath.row < arr.count)
            {
            NSDictionary *detailDict = arr[indexPath.row];
            NSString *strUrl = detailDict[@"act"];
            if(strUrl.length > 0)
            {
                if([strUrl rangeOfString:@"#invit"].location != NSNotFound)
                {
                    NSArray *arr = [Tool getShareParams:strUrl];
                    [self share:arr];
                }
                else if ([strUrl rangeOfString:@"#callapp"].location != NSNotFound)
                {
                    NSArray *arr =  [Tool getShareParams:strUrl];
                    [self callApp:arr];
                }

                else
                {
                    //NSString *str = [NSString stringWithFormat:@"%@&uap=ios",strUrl];
                    [self jumpDetail:strUrl];
                }
            }
        }
    }
    }
}
-(void)callApp:(NSArray *)arr
{
    NSString *cmd = arr[1];
    if([cmd isEqualToString:@"share"]||[cmd isEqualToString:@"weixin"])
    {
        [self share:arr
         ];
    }
}

-(void)loadData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   NSString *tk = [userDefault objectForKey:@"tk"];
    NSDictionary *paramers = [[NSDictionary alloc]initWithObjectsAndKeys:@"getaccount",@"cmd",@"iOS",@"os",tk,@"tk", nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        if ([resultBlock count] > 0)
        {
            dataDcit = [[NSDictionary alloc]initWithDictionary:resultBlock];
            [collView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            NSString *imgUrl = dataDcit[@"userImg"];
            [userDefault setObject:imgUrl forKey:@"headImg"];
        }
        else
        {
           [self showTip];
        }
            
 
    }];
}

-(void)showTip
{
    if(dataDcit == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"exception") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark 建立和其他导航栏一样的左右两个按钮，放在导航来之上
//nav上的加号。
-(void)setUpAdd
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:@"appinfo"];
    logoBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
  //  CGFloat logoY;
#if KGOLD
    //logo
    logoBtn.frame =  CGRectMake(7,20+2, 120, 40);
    logoBtn.userInteractionEnabled = NO;
    NSString *imgStr = dict[@"applogol"];
#elif KMIN
    logoBtn.frame =  CGRectMake(7,20+2, 40, 40);
    [logoBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *imgStr = dict[@"pull"];
#endif
    logoBtn.tag = 890;
    [logoBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    if(imgStr.length > 0)
    {
        logoBtn.bgImg = imgStr;
    }
    else
    {
#if KGOLD
        [logoBtn setImage:[UIImage imageNamed:@"logog"] forState:UIControlStateNormal];
#endif
    }
   // [self.view insertSubview:logoBtn aboveSubview:self.navigationController.navigationBar];
   [self.tabBarController.view addSubview:logoBtn];
    [self setUpPullBtn:dict];
    
}
-(void)setUpPullBtn:(NSDictionary*)dict
{
#if KGOLD
    NSString *imgStr = dict[@"pull"];
#elif KMIN
    NSString *imgStr = dict[@"msgico"];
#endif
    CGFloat logoY;
    if(StatuesHeight == 40)
    {
        logoY = 0;
    }
    else
    {
        logoY = 20;
    }

    addBtn = [self.tabBarController.view viewWithTag:654];
    if(!addBtn)
    {
        addBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
        if(imgStr.length > 0)
        {
            addBtn.bgImg = imgStr;
        }
        addBtn.tag = 654;
        addBtn.frame = CGRectMake(width1-47, 20+2, 40, 40);
#if KGOLD
#elif KMIN
        //小红点
        redView = [[UIView alloc]initWithFrame:CGRectMake(40-6, 3, 6, 6)];
        redView.tag = 777;
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = 3;
      //  redView.hidden = YES;
        [addBtn addSubview:redView];
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSDictionary *dict = [userDefault objectForKey:@"messasge"];
        NSInteger num = [userDefault integerForKey:@"login"];

        if(dict.count > 0 && num == 1)
        {
            redView.hidden = NO;
        }
        else
        {
            redView.hidden = YES;
        }
#endif
        
        [addBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:addBtn];
    }
    else
    {
        if(imgStr.length > 0)
        {
            addBtn.bgImg = imgStr;
        }
    }
    
}
#pragma -mark rightBtnClick:
-(void)rightBtnClick:(UIButton *)btn
{
#if KGOLD
    [self setUpTbView:btn];
#elif KMIN
    //跳转到消息列表
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"login"] == 0) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
        alter.tag = 502;
        [alter show];
    }
    else
    {
        MsgListViewController *msgList = [[MsgListViewController alloc]initWithNibName:@"MsgListViewController" bundle:nil];
     //   redView.hidden = YES;
        NSDictionary *msgDict = [userDefault objectForKey:@"messasge"];
        if(msgDict.count > 0)
        {
            NSString *str = @"isLogin";
            NSDictionary *dict = @{@"login":@"login",@"msg":@[]};
            [[NSNotificationCenter defaultCenter]postNotificationName:str object:dict];
            NSUserDefaults *userDefault = [NSUserDefaults new];
            [userDefault setObject:nil forKey:@"messasge"];
        }
        [self.navigationController pushViewController:msgList animated:YES];
    }
    
#endif
}
-(void)leftBtnClick:(UIButton *)btn
{
    [self setUpTbView:btn];
}
-(void)setUpTbView:(UIButton *)sender
{
    if(!tbView)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        tap.delegate = self;
    //    bgView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
        [bgView addGestureRecognizer:tap];
/////////////////////////////////////////////
        [self.tabBarController.view insertSubview:bgView aboveSubview:addBtn];
       // [self.view addSubview:bgView];
#if KGOLD
        tbView = [[UITableView alloc]initWithFrame:CGRectMake(width1*2/3-30,20+self.navigationController.navigationBar.frame.size.height, width1/3+30, self.tbArr.count*44) style:UITableViewStylePlain];
#elif KMIN
        tbView = [[UITableView alloc]initWithFrame:CGRectMake(0,20+self.navigationController.navigationBar.frame.size.height, width1/3+30, self.tbArr.count*44) style:UITableViewStylePlain];
#endif
        [self.view addSubview:tbView];
        [bgView addSubview:tbView];
        tbView.scrollEnabled =  NO;
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.separatorColor = [UIColor blackColor];
        tbView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UINib *nib = [UINib nibWithNibName:@"AddTableViewCell" bundle:nil];
        [tbView registerNib:nib forCellReuseIdentifier:@"add"];
        tbView.hidden = YES;
        
    }
    sender.selected = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    [tbView.layer addAnimation:animation forKey:@"animation"];
    bgView.hidden = NO;
    tbView.hidden = NO;
    [tbView reloadData];
    
    
}
-(void)tapBg:(UITapGestureRecognizer *)tapGesture
{
    tapGesture.view.hidden = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    animation.subtype = kCATransitionReveal;
    [tbView.layer addAnimation:animation forKey:@"animation"];
    tbView.hidden = YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   // NSLog(@"%@",[touch.view.superview class]);
   // NSLog(@"%@",[gestureRecognizer.view class]);
    //截获手势（解决手势冲突问题）
    if([touch.view.superview isKindOfClass:[UITableViewCell class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 //   NSLog(@"%lu",(unsigned long)self.tbArr.count);
    return self.tbArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add"];
    NSDictionary *dict = [self.tbArr objectAtIndex:indexPath.row];
    cell.info = dict;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bgView.hidden = YES;
    NSDictionary *dict = self.tbArr[indexPath.row];
    NSString *str = dict[@"act"];
    if([str isEqualToString:@"#set"])
    {
        TableViewController *setting = [[TableViewController alloc]init];
        [self.navigationController pushViewController:setting animated:YES];
    }
    else if ([str isEqualToString:@"#msg"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            alter.tag = 502;
            [alter show];
        }
        else
        {
            MsgListViewController *msgList = [[MsgListViewController alloc]initWithNibName:@"MsgListViewController" bundle:nil];
            NSUserDefaults *userDefault = [NSUserDefaults new];
            [userDefault setObject:nil forKey:@"messasge"];
            [self.navigationController pushViewController:msgList animated:YES];
        }
    }
    else if ([str rangeOfString:@"#callapp"].location != NSNotFound)
    {
        NSArray *arr =  [Tool getShareParams:str];
        
        [self callApp:arr];
    }
    else if ([str isEqualToString:@"#about"])
    {
        AboutUsViewController *aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        [self.navigationController pushViewController:aboutus animated:YES];
    }
    else if ([str isEqualToString:@"#out"])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            alter.tag = 502;
            alter.backgroundColor = [UIColor redColor];
            [alter show];
        }
        else
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"confirmLogout") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"logout"), nil];
            alter.tag = 501;
            [alter show];
        }
        
    }
    else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (![userDefault integerForKey:@"login"]) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            [alter show];
        }
        else
        {
            NSString *str = dict[@"act"];
            NSString *title = dict[@"title"];
            SearchView *search = [self.navigationController.navigationBar viewWithTag:711];
            if(search)
            {
                search.hidden = YES;
            }
            
            [self pushController:str title:title];
        }
        
    }
    
    
}
-(void)pushController:(NSString *)strurl title:(NSString *)title
{
    BannerDetailViewController *personalDetail = [[BannerDetailViewController alloc]init];
    personalDetail.herfStr = strurl;
    [self.navigationController pushViewController:personalDetail animated:YES];
}
/*
 我的贷款
 */

-(void)jumpDetail:(NSString *)strUrl
{
    [self pushController:strUrl];
}


-(void)pushController:(NSString *)strurl
{
    BannerDetailViewController *banner = [[BannerDetailViewController alloc]init];
    banner.herfStr = strurl;
    a = 0;
    [self.navigationController pushViewController:banner animated:YES];
}
-(void)share:(NSArray *)paramsArr
{
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
    [shareView share:paramsArr controller:self];
    [self.tabBarController.view addSubview:shareView];

}
#pragma -mark LogDelegate
-(void)jumpLogin
{
    [self changeLogin];
}
-(void)headBtnJump:(NSString*)url
{
    [self jumpDetail:url];
}
-(void)unlogTap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"未登录");
    [self unLogTipView];
}
-(void)unLogSwipDown:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"下未登录");
    [self unLogTipView];
}
-(void)unLogSwipUp:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"上未登录");
    [self unLogTipView];
}
-(void)unLogTipView
{
    if(!unLoglabel)
    {
        CGSize size = [ZGS(@"unLog") getStringSize:[UIFont systemFontOfSize:12] width:width1];
        CGFloat w = size.width+20;
        CGFloat h = size.height+15;
        CGFloat y = _unLogView.frame.size.height-50-h;
        unLoglabel = [[UILabel alloc]initWithFrame:CGRectMake((width1-w)/2, y,w , h)];
        unLoglabel.backgroundColor = RGB(96, 96, 96);
        unLoglabel.textColor = [UIColor whiteColor];
        unLoglabel.font = [UIFont systemFontOfSize:12];
        unLoglabel.textAlignment = NSTextAlignmentCenter;
        unLoglabel.text = ZGS(@"unLog");
        unLoglabel.layer.cornerRadius = h/2;
        unLoglabel.layer.masksToBounds = YES;
        [_unLogView addSubview:unLoglabel];
    }
    unLoglabel.hidden = NO;
    
    __weak typeof(self)vc = self;
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:0.5f target:vc selector:@selector(unLogHidden) userInfo:nil repeats:NO];
    //10以后的方法
  //  [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^(NSTimer * _Nonnull timer) {
     //   unLoglabel.hidden = YES;
   // }];
}
-(void)unLogHidden
{
    unLoglabel.hidden = YES;
}
-(void)dealloc
{
    [timer invalidate];
    timer = nil;
}
#pragma -mark 懒加载
-(UIView *)unLogView
{
    if(!_unLogView)
    {
        _unLogView = [[UIView alloc]init];
        _unLogView.backgroundColor = [UIColor clearColor];//[[UIColor redColor] colorWithAlphaComponent:0.3];
        _unLogView.frame = CGRectMake(0, 160, width1, height1-TABANOHEIGHT-HEADHEIGHT);
        [self.view insertSubview:_unLogView aboveSubview:collView];
        //点击
        UITapGestureRecognizer *unLogViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unlogTap:)];
        [_unLogView addGestureRecognizer:unLogViewTap];
        //滑动
        
        UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(unLogSwipDown:)];
        swipDown.direction = UISwipeGestureRecognizerDirectionDown;
        [_unLogView addGestureRecognizer:swipDown];
        
        
        UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(unLogSwipUp:)];
        swipUp.direction = UISwipeGestureRecognizerDirectionUp;
        [_unLogView addGestureRecognizer:swipUp];
    }
    return _unLogView;
}

@end
