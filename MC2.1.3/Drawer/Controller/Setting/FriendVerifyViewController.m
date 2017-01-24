//
//  FriendVerifyViewController.m
//  MiningCircle
//
//  Created by ql on 16/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "FriendVerifyViewController.h"
#import "NSString+Exten.h"
#import "HudView.h"
#import <RongIMKit/RongIMKit.h>
#import "DataManager.h"
#import "PwdEdite.h"
@interface FriendVerifyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyInfo;

@end

@implementation FriendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"朋友验证";
    
    //取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:ZGS(@"cancle") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize cancleSize = [ZGS(@"cancle") getStringSize:[UIFont systemFontOfSize:17] width:100];
    cancleBtn.frame = CGRectMake(0, 0, cancleSize.width+10,30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    //发送
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:ZGS(@"send") forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize sendSize = [ZGS(@"send") getStringSize:[UIFont systemFontOfSize:17] width:100];
    sendBtn.frame = CGRectMake(0, 0, sendSize.width+10,30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    NSString *userName = [DEFAULT objectForKey:@"username"];
    self.verifyInfo.text = [NSString stringWithFormat:@"我是%@",userName];

}
-(void)cancleClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark 添加好友
-(void)sendClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    NSString *sourceID = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?addFriend&sourceUserId=%@&targetUserId=%@&targetUserName=%@&message=%@&opration=add",MAINURL,sourceID,_userID,_name,self.verifyInfo.text];
    
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSInteger num = [resultBlock[@"code"] integerValue];
        if(num == 200)
        {
            NSLog(@"发送成功");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            sender.userInteractionEnabled = YES;
            [alertView show];
            NSLog(@"发送失败");
        }

    }];
//    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }];
//    
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

@end
