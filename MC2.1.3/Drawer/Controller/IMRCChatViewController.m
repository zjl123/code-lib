//
//  IMRCChatViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "IMRCChatViewController.h"
#import "Tool.h"
#import "IMAddFirendViewController.h"
#import "FriendDetailViewController.h"
#import "GroupInfoSettingViewController.h"
#import "RCIMDataSource.h"
#import "PrivateInfoSettingViewController.h"
@interface IMRCChatViewController ()<RCMessageCellDelegate>
{
    NSArray *groupMemberArr;
}
@end

@implementation IMRCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //群
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if(self.conversationType == ConversationType_GROUP)
    {
        [btn setImage:[UIImage imageNamed:@"group_icon"] forState:UIControlStateNormal];
    }
    else if (self.conversationType == ConversationType_PRIVATE)
    {
        
        [btn setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
    }
    [self refreshUserInfoOrGroupInfo];
    //更改群名
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(renameGroupName:) name:@"renameGroupName" object:nil];
    //删除聊天记录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ClearHistoryMsg:) name:@"ClearHistoryMsg" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"renameGroupName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ClearHistoryMsg" object:nil];
}
-(void)renameGroupName:(NSNotification *)notify
{
    self.title = [notify object];
}

-(void)ClearHistoryMsg:(NSNotification *)notify
{
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}
-(void)btnClick:(UIButton *)sender
{
    if(self.conversationType == ConversationType_GROUP)
    {
        //设置群信息
        GroupInfoSettingViewController *groupSetting = [[GroupInfoSettingViewController alloc]initWithNibName:@"GroupInfoSettingViewController" bundle:nil];
     //   groupSetting.memArr = [NSMutableArray arrayWithArray:groupMemberArr];
        NSLog(@"...%@",self.targetId);
        groupSetting.groupId = self.targetId;
        [self.navigationController pushViewController:groupSetting animated:YES];
    }
    else if (self.conversationType == ConversationType_PRIVATE)
    {
        PrivateInfoSettingViewController *privateSetting = [[PrivateInfoSettingViewController alloc]initWithNibName:@"PrivateInfoSettingViewController" bundle:nil];
        privateSetting.userId = self.targetId;
        [self.navigationController pushViewController:privateSetting animated:YES];
    }
}
- (void)didTapCellPortrait:(NSString *)userId {
    if (self.conversationType == ConversationType_GROUP ||
        self.conversationType == ConversationType_DISCUSSION||self.conversationType == ConversationType_PRIVATE) {
        if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            NSLog(@"ccccc");
            
            //跳转到详情（是好友跳转到好友详情，不是好友跳转到添加好友）
            
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
            BOOL isFriend = NO;
            NSDictionary *friendDict;
            for (NSDictionary *dict in mutArr) {
                if ([dict[@"userId"] isEqualToString:self.targetId]) {
                    friendDict = dict;
                    isFriend = YES;
                    break;
                }
            }
            if(isFriend)
            {
                [self goToFriendDetail:friendDict];
            }
            else
            {
                [self goToAddFriend:self.targetId];
            }
        } else {
            NSString *userId = [RCIM sharedRCIM].currentUserInfo.userId;
            if(userId.length == 0)
            {
                return;
            }
            NSString *userName = [DEFAULT objectForKey:@"username"];
            userName = [Tool judgeNil:userName];
            NSString *userPotrail = [RCIM sharedRCIM].currentUserInfo.portraitUri;
            userPotrail = [Tool judgeNil:userPotrail];
            NSDictionary *dict = @{@"userId":userId,@"userName":userName,@"userImg":userPotrail};
            [self goToFriendDetail:dict];
        }
    }
}
-(void)goToFriendDetail:(NSDictionary *)dict
{
    FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]initWithNibName:@"FriendDetailViewController" bundle:nil];
    friendDetail.model = [[IMUserModel alloc]initWithDictionary:dict];
    [self.navigationController pushViewController:friendDetail animated:YES];
}
-(void)goToAddFriend:(NSString *)userId
{
    IMAddFirendViewController *addFriend = [[IMAddFirendViewController alloc]initWithNibName:@"IMAddFirendViewController" bundle:nil];
    addFriend.userID = userId;
    [self.navigationController pushViewController:addFriend animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshUserInfoOrGroupInfo
{
    if(self.conversationType == ConversationType_PRIVATE)
    {
    
    }
    else if (self.conversationType == ConversationType_GROUP)
    {
        [RCDataSource getAllMembersOfGroup:self.targetId result:^(NSArray<NSString *> *userIdList) {
            groupMemberArr = userIdList;
        }];
    }
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
