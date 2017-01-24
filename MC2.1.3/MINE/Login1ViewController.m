//
//  Login1ViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/31.
//  Copyright (c) 2015年 zjl. All rights reserved.
//  自动登录 是：2，否：3
//  登录 是：1 否：0

#import "Login1ViewController.h"
//#import "RegistViewController.h"
#import "BannerDetailViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "UIButton+WebCache.h"
#import "BgImgButton.h"
#import "UMMobClick/MobClick.h"
//#import <RongIMKit/RongIMKit.h>
#import "RCIMDataSource.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "Server.h"
@interface Login1ViewController ()
{
    AFHTTPSessionManager *_manager;
    NSString *strUrl;
    NSString *time;
    GreyView *greyView;
    ActivityView *activity;
    UIView *bgView ;
}
@property (weak, nonatomic) IBOutlet UILabel *tipLogLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@end

@implementation Login1ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = ZGS(@"login");
    self.userNameLabel.text = ZGS(@"UserName") ;
    self.pwdLabel.text = ZGS(@"pwd");
    self.autoLoginLabel.text = ZGS(@"autoLogin");
    self.tipLogLabel.text = ZGS(@"logTip");
    self.userName.placeholder = ZGS(@"nameTip");
    self.password.placeholder = ZGS(@"pwdTip");

    [_login setTitle:ZGS(@"login") forState:UIControlStateNormal];
    [_registerBtn setTitle:ZGS(@"register") forState:UIControlStateNormal];
   // _registerBtn.titleLabel.contentMode = UIViewContentModeRight;
    [_forgetPwdBtn setTitle:ZGS(@"ForgotPassWord") forState:UIControlStateNormal];
    _userName.tag =400;
    _password.tag = 401;
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSInteger num = [userDefault integerForKey:@"autoLogin"];
   if(num == 2)
   {
       [self.remindPwd setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
       if([userDefault objectForKey:@"username"] !=nil)
       {
           self.userName.text = [userDefault objectForKey:@"logName"];
           BOOL isRemind = [userDefault integerForKey:@"isRemind"];
           if(isRemind)
           {
               self.password.text = [self getPassword];
           }
       }

   }
    else
    {
        [self.remindPwd setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }
    
    
    self.login.layer.cornerRadius = self.login.frame.size.height/2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemindPwd:)];
    self.remindPwdLabel.userInteractionEnabled = YES;
    [self.remindPwdLabel addGestureRecognizer:tap];
    
    
    //通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
-(NSString *)getPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *password = [userDefault objectForKey:@"entryptPwd"];
    if(password.count > 0)
    {
    password = [PwdEdite decoding:password];
    NSString *pwd = [password objectForKey:@"password"];
    return pwd;
    }
    else
    {
        return nil;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _userName.delegate = self;
    _password.delegate = self;
    
    
}

-(void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapRemindPwd:(UITapGestureRecognizer *)tap
{
    [self remindPwd:self.remindPwd];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 获取token（IM）
-(void)getToken:(NSString *)userID
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *username = [DEFAULT objectForKey:@"username"];
    NSString *userid = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?getToken&userName=%@&userId=%@",MAINURL,username,userid];
   getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSString *token = resultBlock[@"token"];
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(token.length > 0&& code == 200)
        {
            [DEFAULT setObject:token forKey:@"IMToken"];
            //创建好友列表
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate initIM];
            [RCDataSource getAddressBook:^(NSDictionary *addressDict) {
                
            }];
        }

    }];
    
    
    
//    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//        NSLog(@"gettt%@",dict);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}
#pragma -mark 登录
- (IBAction)loginBtn:(UIButton *)sender {
    self.tip.text = @"";
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-self.navigationController.navigationBar.frame.size.height-20-self.tabBarController.tabBar.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:0.1];
    [self.view addSubview:bgView];
   greyView = [[GreyView alloc]init];
    greyView.frame = CGRectMake(0, 0, 80, 80);
    greyView.center = CGPointMake(width1/2, height1/2-80);
    [bgView addSubview:greyView];
   activity = [[ActivityView alloc]init];
    activity.frame = CGRectMake(0, 0, 50, 50);
    activity.center = greyView.center;
    [bgView addSubview:activity];
    [activity startAnimating];
    
  //保存数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userName.text forKey:@"username"];
    //同步到磁盘
    [userDefaults synchronize];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"cmd",@"iOS",@"os",self.userName.text,@"username",self.password.text,@"password", nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
        if(resultBlock.count > 0)
        {
            [self loginData:resultBlock];
        }
        else
        {
            [bgView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"exception") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
            [alert show];
        }
    }];
    

//       
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}
-(void)loginData:(NSDictionary *)resultBlock
{
    int flag = -4;
    if ([resultBlock count] > 0) {
        flag = [[resultBlock objectForKey:@"ret"] intValue];
    }
    //NSLog(@"%@",result);
    [activity removeFromSuperview];
    [greyView removeFromSuperview];
    [bgView removeFromSuperview];
    
    if (flag == 0) {
        NSString *str = [NSString stringWithFormat:@"%@",resultBlock[@"cartcount"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"cart" object:str];
        NSString *username = [resultBlock objectForKey:@"username"];
        NSString *usermobile = [resultBlock objectForKey:@"usermobile"];
        [DEFAULT setObject:username forKey:@"username"];
        [DEFAULT setObject:usermobile forKey:@"usermobile"];
        NSString *userid = [resultBlock objectForKey:@"userid"];
        [DEFAULT setObject:userid forKey:@"userid"];
     //   [self getMessage:userid];
        [[Server shareInstance] getMessage:userid];
        
        [DEFAULT setObject:[resultBlock objectForKey:@"tk"] forKey:@"tk"];
        NSString *usercat = resultBlock[@"usercat"];
        [DEFAULT setObject:usercat forKey:@"usercat"];
        int num = 1;
        //登录成功
        //获取token
        [self getToken:userid];
        //友盟统计
        [MobClick profileSignInWithPUID:self.userName.text];
        [DEFAULT setInteger:num forKey:@"login"];
        // [userDefaults setObject:userid forKey:@"userid"];
        [DEFAULT synchronize];
        BOOL isRemind = [DEFAULT integerForKey:@"isRemind"];
        if(isRemind)
        {
            NSString *logName = self.userName.text;
            [DEFAULT setObject:logName forKey:@"logName"];
            NSDictionary *dict = @{@"password":self.password.text};
            //密码加密
            NSDictionary *entryptPwd = [PwdEdite ecoding:dict];
            [DEFAULT setObject:entryptPwd forKey:@"entryptPwd"];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (flag == -2)
    {
        [bgView removeFromSuperview];
        self.password.text = nil;
        self.tip.text = [resultBlock objectForKey:@"msg"];
    }
    else if (flag == -3)
    {
        [bgView removeFromSuperview];
        self.password.text = nil;
        self.userName.text = nil;
        self.tip.text = [resultBlock objectForKey:@"msg"];
    } else if (flag == -4) {
        [bgView removeFromSuperview];
        self.password.text = nil;
        self.userName.text = nil;
        self.tip.text = ZGS(@"dataerror");
    }

}
#pragma -mark 忘记密码
- (IBAction)passwordForgeting:(UIButton *)sende{

    NSString *strurl1;
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSDictionary *dict = [userDefault objectForKey:@"appinfo"];
    strurl1 = dict[@"getpwdurl"];
    [self pushController:strurl1];
    
}
#pragma -mark 新用户注册
- (IBAction)userRegister:(UIButton *)sender {
    NSString *strurl1;
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSDictionary *dict = [userDefault objectForKey:@"appinfo"];
    strurl1 = dict[@"regurl"];
    [self pushController:strurl1];
}
-(void)pushController:(NSString *)strurl
{
    BannerDetailViewController *reg = [[BannerDetailViewController alloc]init];
    reg.herfStr = strurl;
    [self.navigationController pushViewController:reg animated:YES];
}
#pragma -mark 点击返回收回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 400)
    {
        [_password becomeFirstResponder];
    }
    else
    {
    [textField resignFirstResponder];
    }
    return YES;
}

#pragma -mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
    //滚回来
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //滚出去
    
}

#pragma -mark 记住密码
- (IBAction)remindPwd:(UIButton *)sender {
    static BOOL isRemind = NO;
    isRemind =!isRemind;
    //保存数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:isRemind forKey:@"isRemind"];
    if(isRemind)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [userDefaults setInteger:2 forKey:@"autoLogin"];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [userDefaults setInteger:3 forKey:@"autoLogin"];
    }

    
}
@end
