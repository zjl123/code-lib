//
//  changeMoneyPassViewController.m
//  MiningCircle
//
//  Created by jinzhenxin on 15/8/20.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "changeMoneyPassViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "Login1ViewController.h"
@interface changeMoneyPassViewController () <UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *presdentPwd;
- (IBAction)CommitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *comfimAgain;
@property (weak, nonatomic) IBOutlet UITextField *nowPwd;
@property (weak, nonatomic) IBOutlet UILabel *errorTip;
@property (weak, nonatomic) IBOutlet UILabel *currentPwdLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelNew;

@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UIButton *done;

@end

@implementation changeMoneyPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPwdLabel.text = ZGS(@"pwd");
    self.labelNew.text = ZGS(@"newPwd");
    self.confirmLabel.text = ZGS(@"comPwd");
    _presdentPwd.placeholder = ZGS(@"nowTip");
    _nowPwd.placeholder = ZGS(@"newTip");
    _comfimAgain.placeholder = ZGS(@"comTip");
    [_done setTitle:ZGS(@"submit") forState:UIControlStateNormal];
    _presdentPwd.tag = 300;
    _nowPwd.tag = 301;
    _comfimAgain.tag = 302;
    _presdentPwd.delegate = self;
    _nowPwd.delegate = self;
    _comfimAgain.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
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


- (IBAction)CommitBtn:(id)sender {
    
    _errorTip.text =@"";
    
    if ([self.presdentPwd.text  isEqualToString:@""]||[self.nowPwd.text  isEqualToString: @""]||[self.comfimAgain.text  isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"input") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
        [alert show];

    }
    else
    {
    NSDictionary *dict;
    if([self.cmd isEqualToString:@"setpwd"])
    {
     dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.cmd,@"cmd",@"ios",@"os", self.presdentPwd.text,@"pwd_old", self.nowPwd.text,@"pwd_new", nil];
    }
    else if ([self.cmd isEqualToString:@"setmoneypwd"])
    {
        dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.cmd,@"cmd",@"ios",@"os", self.presdentPwd.text,@"moneypwd_old", self.nowPwd.text,@"moneypwd_new", nil];
    }
    
    
    
   if([self.nowPwd.text isEqualToString:self.comfimAgain.text])
   {
       
       [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
           
           if ([resultBlock count] == 0) {
               UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"alertFailed") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
               [av show];
               return;
           }
           int ret = [[resultBlock objectForKey:@"ret"] intValue];
           if(ret == 0)
           {
               
               if([self.cmd isEqualToString:@"setpwd"])
               {
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"alertSuc") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
                   [alert show];
               }
               else if ([self.cmd isEqualToString:@"setmoneypwd"])
               {
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"fund_alertSuc") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                   [alert show];
               }
               self.presdentPwd.text = nil;
               self.nowPwd.text = nil;
               self.comfimAgain.text = nil;
               
           }
           else if (ret == -3)
           {
               _errorTip.text =ZGS(@"pwderror");
               self.presdentPwd.text = nil;
               self.nowPwd.text = nil;
               self.comfimAgain.text = nil;
               
           }
           else if (ret == -2)
           {
               _errorTip.text = ZGS(@"alertFailed");
               self.presdentPwd.text = nil;
               self.nowPwd.text = nil;
               self.comfimAgain.text = nil;
           }
           else
           {
               UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"alertFailed") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
               [av show];
           }

       }];
       }
    else
    {
        self.errorTip.text = ZGS(@"errorTip");
        self.nowPwd.text = nil;
        self.comfimAgain.text = nil;
    }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
    Login1ViewController *login = [[Login1ViewController alloc]initWithNibName:@"Login1ViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if(textField.tag == 300)
    {
        [_nowPwd becomeFirstResponder];
    }
    if(textField.tag == 301)
    {
        [_comfimAgain becomeFirstResponder];
    }
    if(textField.tag == 302)
    {
    [textField resignFirstResponder];
    }
    
    return YES;
}


@end
