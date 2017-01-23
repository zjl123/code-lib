//
//  Login1ViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/7/31.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
#import "CustomField.h"
@interface Login1ViewController : BackButtonViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *remindPwd;
@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet CustomField *userName;
@property (weak, nonatomic) IBOutlet UILabel *remindPwdLabel;

@property (weak, nonatomic) IBOutlet CustomField *password;
- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)passwordForgeting:(UIButton *)sender;
- (IBAction)userRegister:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *tip;
- (IBAction)remindPwd:(UIButton *)sender;
@end
