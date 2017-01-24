//
//  RemarkNameViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/20.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "RemarkNameViewController.h"
#import "ImgButton.h"
#import "Tool.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import <RongIMKit/RongIMKit.h>
@interface RemarkNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;

@end

@implementation RemarkNameViewController
{
    ImgButton *saveBtn;
    NSString *originalStr;
    NSMutableArray *mutArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.remarkLabel.text = self.remarkTip;
    self.remarkField.text = self.remarkFieldTip;
    self.remarkField.returnKeyType = UIReturnKeyDone;
    saveBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 50, 32);
    saveBtn.title = ZGS(@"save");
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    saveBtn.layer.cornerRadius = 2;
    saveBtn.normalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    saveBtn.backgroundColor = BLUECOLOR;
    saveBtn.userInteractionEnabled = NO;
  //  [saveBtn addTarget:self action:@selector(saveRemarks:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.remarkField.delegate = self;
    [self.remarkField addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    originalStr = self.remarkField.text;
}
-(void)textFieldEditChange:(UITextField *)theTextField
{
    if([theTextField.text isEqualToString:originalStr])
    {
        saveBtn.userInteractionEnabled = NO;
        saveBtn.normalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    else
    {
        saveBtn.userInteractionEnabled = YES;
        saveBtn.normalColor = [UIColor whiteColor];
    }
}
#pragma -mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(str.length < 15)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:originalStr])
    {
        [textField resignFirstResponder];
    }
    else
    {
        [self saveClick:saveBtn];
    }

    
    return YES;
}
-(void)saveClick:(ImgButton *)sender
{
   // NSLog(@"hhhhhh");
    sender.userInteractionEnabled = NO;
    if([_judgeStr isEqualToString:@"qun"])
    {
        [self modifyGroupName];
    }
    else if ([_judgeStr isEqualToString:@"myName"])
    {
        [self modifyMyNameInGroup];
    }
    else
    {
        [self postServer];
    }
    
   // }
    
}
#pragma -mark 修改我在群聊的昵称
-(void)modifyMyNameInGroup
{
    NSString *hostUserId = [DEFAULT objectForKey:@"userid"];
    NSString *getStr = [NSString stringWithFormat:@"%@rongyun.do?userGroupNameRemark&groupId=%@&userId=%@&newGroupName=%@",MAINURL,self.userid,hostUserId,self.remarkField.text];
    getStr = [getStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getStr parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            [self.transDelegate transformValues:_remarkField.text];
            [self.navigationController popViewControllerAnimated:YES];
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(groupWrite) object:nil];
            [thread start];
        }
        else
        {
            [self alertShow:@"修改失败"];
            saveBtn.userInteractionEnabled = YES;
        }

    }];
}
#pragma -mark 修改群聊名称
-(void)modifyGroupName
{
    NSString *getStr = [NSString stringWithFormat:@"%@rongyun.do?groupNameRemark&groupId=%@&groupName=%@&opration=Rename",MAINURL,self.userid,self.remarkField.text];
    getStr = [getStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *userName = [DEFAULT objectForKey:@"username"];
    NSDictionary *paramers = @{@"data":@{@"operatorNickname":userName,@"targetGroupName":self.remarkField.text}};
    [[DataManager shareInstance]ConnectServer:getStr parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            
            [self.transDelegate transformValues:_remarkField.text];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"renameGroupName" object:self.remarkField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self alertShow:@"修改失败"];
            saveBtn.userInteractionEnabled = YES;
            
        }

    }];
    

}
-(void)groupWrite
{
    NSMutableArray *memberArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:_userid]];
    NSString *userId = [DEFAULT objectForKey:@"userid"];
    for (int i = 0; i <memberArr.count ; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:memberArr[i]];
        if([dict[@"userId"] isEqualToString:userId])
        {
            [dict setObject:_remarkField.text forKey:@"nameRemark"];
            [memberArr replaceObjectAtIndex:i withObject:dict];
            [Tool writeToFile:memberArr withPath:_userid];
            break;
        }
    }
}
#pragma -mark 修改备注名
-(void)postServer
{
    NSString *sourceId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?nameRemark&sourceUserId=%@&targetUserId=%@&remarkName=%@",MAINURL,sourceId,_userid,_remarkField.text];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            [self.transDelegate transformValues:_remarkField.text];
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(saveName) object:nil];
            [thread start];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self alertShow:@"修改失败"];
            saveBtn.userInteractionEnabled = YES;
        }

    }];
}
-(void)saveName
{
    mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    NSArray *arr = [NSArray arrayWithArray:mutArr];
    
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        NSString *userid = dict[@"userId"];
        if([userid isEqualToString:_userid])
        {
            //保存备注名
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutDict setObject:_remarkField.text forKey:@"nameRemark"];
            [mutArr replaceObjectAtIndex:i withObject:mutDict];
            //写入文件
            [Tool writeToFile:mutArr withPath:@"friend"];
            break;
            
            
        }

    }
}
-(void)alertShow:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
    [alertView show];
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
