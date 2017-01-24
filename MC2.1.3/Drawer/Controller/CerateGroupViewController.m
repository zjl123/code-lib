//
//  CerateGroupViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/24.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "CerateGroupViewController.h"
#import "DataManager.h"
#import "Tool.h"
#import <RongIMKit/RongIMKit.h>
#import "PwdEdite.h"
@interface CerateGroupViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *blueLine;

@end

@implementation CerateGroupViewController
{
    UIButton *rigntBtn;
    HudView *hud;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameField.delegate = self;
     rigntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rigntBtn.frame = CGRectMake(0, 0, 50, 30);
     self.isPost = NO;
    if(_isCreate)
    {
       
       [rigntBtn setTitle:ZGS(@"Create") forState:UIControlStateNormal];
    }
    else
    {
     //   self.isPost = YES;
       // [rigntBtn setTitle:ZGS(@"Modify") forState:UIControlStateNormal];
        rigntBtn.hidden = YES;
        self.nameField.hidden = YES;
        self.blueLine.hidden = YES;
    }
    [rigntBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigntBtn];

    self.nameField.placeholder = @"填写群名称（2-10个字符）";
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:@"填写群名称（2-10个字符）"];
    [mutStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] range:NSMakeRange(0, mutStr.length)];
    _nameField.attributedPlaceholder = mutStr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_imgView addGestureRecognizer:tap];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.img)
    {
        _imgView.image = self.img;
    }
}
//-(void)setPicLine:(NSString *)picLine
//{
//  //  self.picLine = picLine;
//    }
-(void)setModifyLine:(NSString *)modifyLine
{
    if(!_isCreate)
    {
        [self sendGroupPic:modifyLine andGroupId:self.targetId];
    }

}
-(void)tap:(UIGestureRecognizer *)tap
{
    [self selectedImage];
}
-(void)doneClick:(UIButton *)sender
{
    [_nameField resignFirstResponder];
    
    //创建群
    NSString *nameStr = [self.nameField.text copy];
    nameStr = [nameStr
               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //群组名称需要大于2位
    if ([nameStr length] == 0) {
        [self Alert:@"群组名称不能为空"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    //群组名称需要大于2个字
    else if ([nameStr length] < 2) {
        [self Alert:@"群组名称过短"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    //群组名称需要小于10个字
    else if ([nameStr length] > 10) {
        [self Alert:@"群组名称不能超过10个字"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        //创建
        sender.userInteractionEnabled = NO;
        [self creatGroup:nameStr];
    }
}
-(void)creatGroup:(NSString *)str
{
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
    NSString *hostName = [DEFAULT objectForKey:@"username"];
    if(!self.picLine ||self.picLine.length <= 0)
    {
        self.picLine = @"";
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?createGroup&hostId=%@&opration=Create&groupImg=%@",MAINURL,hostId,self.picLine];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"operatorNickname":hostName,@"targetGroupName":str};
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutDict setObject:dict forKey:@"data"];
    [mutDict setObject:_useridArr forKey:@"userIds"];
    
    [[DataManager shareInstance]ConnectServer:getUrl parameters:mutDict isPost:YES result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            NSDictionary *result = resultBlock[@"groupCreateResult"];
            NSInteger code = [result[@"code"] integerValue];
            if(code == 200)
            {
                NSString *groupId = dict[@"GroupId"];
                RCGroup *group = [[RCGroup alloc]init];
                group.groupName = str;
                group.groupId = groupId;
                group.portraitUri = self.picLine
                ;
                [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:groupId];
                //取消键盘
                [self.nameField resignFirstResponder];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"创建成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                NSString *lastTime = dict[@"lastAccessTime"];
                if(lastTime)
                {
                    //存时间
                    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:lastTime];
                    [thread start];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                rigntBtn.userInteractionEnabled = YES;
                [self Alert:@"创建失败"];
                
            }
        }
        else
        {
            rigntBtn.userInteractionEnabled = YES;
        }
 
    }];
}
#pragma -mark 存时间
-(void)thread:(id)time
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    
    [mutDict setObject:time forKey:@"lastAccessTime"];
    [Tool writeToFile:mutDict withPath:@"time"];
}
- (void)Alert:(NSString *)alertContent {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertContent
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)sendGroupPic:(NSString *)line andGroupId:(NSString *)groupId
{
    [self loadHudView];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?savePic&imgUrl=%@&targetId=%@",MAINURL,line,groupId];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            [hud stopShow];
          RCGroup *group =   [[RCIM sharedRCIM]getGroupInfoCache:self.targetId];
            group.portraitUri = line;
            //刷新
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
            [self.proDelegate transProtrailUrl:line];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];
    //滚回来
    
}
#pragma -mark 点击返回收回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameField resignFirstResponder];
    return YES;
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
