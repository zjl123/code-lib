//
//  IMAddFirendViewController.m
//  MiningCircle
//
//  Created by ql on 16/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "IMAddFirendViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendVerifyViewController.h"
#import "UIImageView+WebCache.h"
#import "IMRCChatViewController.h"
#import "RCIMDataSource.h"
@interface IMAddFirendViewController ()
@property (weak, nonatomic) IBOutlet UIButton *conversationBtn;
- (IBAction)Conversation:(id)sender;
- (IBAction)AddFriend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddFriendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headPoratial;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end

@implementation IMAddFirendViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headPoratial.clipsToBounds = YES;
    self.headPoratial.layer.cornerRadius = 3.0f;
    [self.conversationBtn setTitle:ZGS(@"IMMessage") forState:UIControlStateNormal];
    [self.AddFriendBtn setTitle:ZGS(@"IMAdd") forState:UIControlStateNormal];
    self.conversationBtn.layer.cornerRadius = 3;
    self.AddFriendBtn.layer.cornerRadius = 3;
    self.name.text = _model.name;
    NSURL *url = [NSURL URLWithString:_model.portraitUri];
    [self.headPoratial sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"contact"]];
    if(_model.userId.length > 0)
    {
        _userID = _model.userId;
    }
    
}
-(void)setUserID:(NSString *)userID
{
    _userID = userID;
    [[RCIMDataSource shareInstance]getUserInfoWithUserId:userID completion:^(RCUserInfo *userInfo) {
       
        self.name.text = userInfo.name;
        NSURL *url = [NSURL URLWithString:userInfo.portraitUri];
        [self.headPoratial sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"contact"]];
        
    }];
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

- (IBAction)Conversation:(id)sender {
    IMRCChatViewController *conversation = [[IMRCChatViewController alloc]init];
    //通话类型改变
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = _userID;
    [self.navigationController pushViewController:conversation animated:YES];
}

- (IBAction)AddFriend:(id)sender {
   
    FriendVerifyViewController *friend = [[FriendVerifyViewController alloc]initWithNibName:@"FriendVerifyViewController" bundle:nil];
    friend.userID = _userID;
    friend.name = _model.name;
    //以后改一下动画
    [self.navigationController pushViewController:friend animated:YES];
}
@end
