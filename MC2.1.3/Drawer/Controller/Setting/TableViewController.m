//
//  TableViewController.m
//  MiningCircle
//
//  Created by jinzhenxin on 15/8/19.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "TableViewController.h"
#import "changeMoneyPassViewController.h"
#import "AboutUsViewController.h"
#import "FeedBackViewController.h"
#import "DataManager.h"
#import "Login1ViewController.h"
#import "PwdEdite.h"
#import "GestureTableViewController.h"
#import "HeadDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "GreyView.h"
#import "FGLanguageTool.h"
#import "LanguageViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ActiveViewController.h"
@interface MySettingCell:UITableViewCell <UIAlertViewDelegate>
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@end

@implementation MySettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGFloat w = self.frame.size.width;
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, w-55-40, 35)];
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 25)];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.name];
    //小菊花
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.frame = CGRectMake(170, 10, 30, 30);
    [self.contentView addSubview:self.activity];
    
    
    return self;

}

@end
@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *imageArr;
    GreyView *greyView;
    UIActivityIndicatorView *act;
    
}
@property(nonatomic,strong)UITableView *tb;
@property(nonatomic,strong)NSArray *settingnames;

//类名是大写 变量名首字母小写
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZGS(@"setting");
    //修改标题颜色
   // [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.settingnames =@[@[ZGS(@"alertPhoto")],@[ZGS(@"logPwd"),ZGS(@"fundPwd"),ZGS(@"gesture")],@[ZGS(@"feedback"),ZGS(@"language"),ZGS(@"clearCach")]];
    imageArr = @[@[@"headImageEdit"],@[@"login_psw",@"money_psw",@"lck"],@[@"suggest",@"language",@"clear"]];
    self.tb = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tb.frame = CGRectMake(0, 0, width1, height1-StatuesHeight-self.navigationController.navigationBar.frame.size.height);
    self.tb.delegate = self;
    self.tb.dataSource = self;
    [self.view addSubview:self.tb];
   // [self initIM];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

   // NSLog(@"count%ld",self.settingnames.count);
    
    return [_settingnames[section] count];
  
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingnames.count;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//command + z =  退回原样；
    
    static NSString *identifier = @"cellidentifier";
    
    MySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MySettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.name.text = self.settingnames[indexPath.section][indexPath.row];
  //  NSLog(@"%@",self.settingnames[indexPath.section]);
    cell.imgView.image = [UIImage imageNamed:imageArr[indexPath.section][indexPath.row]];
  //  cell.nextImgView.image = [UIImage imageNamed:@"common_icon_arrow"];
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section ==1)
    {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            [alter show];
        }
        else
        {
            if(indexPath.row == 0)
            {
                changeMoneyPassViewController *changeMoneyPass=[[changeMoneyPassViewController alloc]initWithNibName:@"changeMoneyPassViewController" bundle:nil];
                changeMoneyPass.title = ZGS(@"logPwd");
                changeMoneyPass.cmd = @"setpwd";
                [self.navigationController pushViewController:changeMoneyPass animated:YES];
                
            }
            else if (indexPath.row == 1)
            {
                changeMoneyPassViewController *changeMoneyPass=[[changeMoneyPassViewController alloc]initWithNibName:@"changeMoneyPassViewController" bundle:nil];
                changeMoneyPass.title = ZGS(@"fundPwd");
                changeMoneyPass.cmd = @"setmoneypwd";
                [self.navigationController pushViewController:changeMoneyPass animated:YES];

            }
            else
            {
                GestureTableViewController *gesture = [[GestureTableViewController alloc]init];
                gesture.title = ZGS(@"gesture");
                [self.navigationController pushViewController:gesture animated:YES];
            }
        }
        
    }
   else if(indexPath.section == 2)
    {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if(indexPath.row == 0)
        {
            if ([userDefault integerForKey:@"login"] == 0) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
                [alter show];
            }
            else
            {
                FeedBackViewController *Fb = [[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
                
                [self.navigationController pushViewController:Fb animated:YES];
            }
        }
        else if (indexPath.row == 1)
        {
            //切换语言
            [self jumpToLang];
        }
        else
        {
#if KMIN
            NSString *str = ZGS(@"cleartip");
#elif KGOLD
            NSString *str = @"清空黄金贷本地缓存数据";
#endif
            //清空缓存
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:str  delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
            alert.tag = 503;
            [alert show];
            MySettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //[cell.activity startAnimating];
            act = cell.activity;
        }

    }
    else{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault integerForKey:@"login"] == 0) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
            alter.backgroundColor = [UIColor redColor];
            [alter show];
        }
        else
        {
            HeadDetailViewController *headDetail = [[HeadDetailViewController alloc]initWithNibName:@"HeadDetailViewController" bundle:nil];
            NSUserDefaults *userDefault = [NSUserDefaults new];
            NSString *str = [userDefault objectForKey:@"username"];
            headDetail.name = str;
            headDetail.imgUrl = [userDefault objectForKey:@"headImg"];
            [self.navigationController pushViewController:headDetail animated:YES];
        }
        
    }

}
//#pragma -mark 跳转到扫描二维码页面
//-(void)jumpScanQR
//{
//    ScanQRViewController *scanQR = [[ScanQRViewController alloc]init];
//    [self.navigationController pushViewController:scanQR animated:YES];
//}
#pragma -mark 跳转到语言页面
-(void)jumpToLang
{
    LanguageViewController *lang = [[LanguageViewController alloc]initWithNibName:@"LanguageViewController" bundle:nil];
    [self.navigationController pushViewController:lang animated:YES];
}
-(void)changeLogin
{
    Login1ViewController *login = [[Login1ViewController alloc]initWithNibName:@"Login1ViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 503 && buttonIndex == 1)
    {
        if(buttonIndex == 1)
        {
            [self clearCache];
        }
    }
    else if (alertView.tag == 500)
    {
        if(buttonIndex == 0)
        {
            [self changeLogin];
        }
    }
    else
    {
        if(buttonIndex == 1)
        {
            [self changeLogin];
        }
    }
}
#pragma -mark 清除缓存
-(void)clearCache
{
    [act startAnimating];
    //沙河目录路径
   
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //删除tmp
    if([fileManager fileExistsAtPath:tmpPath])
    {
        NSArray *childFiles = [fileManager subpathsAtPath:tmpPath];
        for (NSString *fileName in childFiles) {
            NSString *absolutePath = [tmpPath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //删除library(保留preference)
    if([fileManager fileExistsAtPath:libPath])
    {
        NSArray *childFiles = [fileManager subpathsAtPath:libPath];
        for (NSString *fileName in childFiles) {
            if([fileName rangeOfString:@"Preferences"].location == NSNotFound)
            {
                NSString *absolutePath = [libPath stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
    //设置postTime为0，重新请求菜单
    NSUserDefaults *userDefault = [NSUserDefaults new];
   // NSString *postTime = [userDefault objectForKey:@"postTime"];
    [userDefault setObject:@"0" forKey:@"postTime"];
    [[SDImageCache sharedImageCache] cleanDisk];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCleanSuc) userInfo:nil repeats:NO];
}
-(void)showCleanSuc
{
    [act stopAnimating];
    CGFloat greyW = 90;
    greyView = [[GreyView alloc]init];
    greyView.frame = CGRectMake(0, 0, greyW, greyW);
    greyView.center = CGPointMake(width1/2, height1/2-90);
    [self.view addSubview:greyView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
    imgView.frame = CGRectMake(greyW/2-15, greyW/2-25, 30, 30);
    [greyView addSubview:imgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, greyW/2+15, 70, 20)];
    label.text = ZGS(@"clearsuc");
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [greyView addSubview:label];
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(removeAlert) userInfo:nil repeats:NO];
}
-(void)removeAlert
{
    [greyView removeFromSuperview];
    
}
#pragma -mark 切换语言
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
