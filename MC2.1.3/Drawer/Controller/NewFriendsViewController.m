//
//  NewFriendsViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "NewFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import <RongIMKit/RongIMKit.h>
#import "Tool.h"
#import "IMRCChatViewController.h"
#import "PwdEdite.h"
@interface NewFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,IMAddFriendsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ZGS(@"IMNewFriend");
    //注册
    UINib *nib = [UINib nibWithNibName:@"NewFriendTableViewCell" bundle:nil];
    [self.tbView registerNib:nib forCellReuseIdentifier:@"NewFriend"];
  //  self.tbView.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriend"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addFriendDelegate = self;
    NSDictionary *dict = _dataArr[indexPath.row];
    //只能用model,不能用status
    cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict = _dataArr[indexPath.row];
    if([dict[@"status"] isEqualToString:@"1"])
    {
        //单聊
        IMRCChatViewController *conversationVC = [[IMRCChatViewController alloc]init];
        conversationVC.targetId = dict[@"userId"];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.title = dict[@"userName"];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}
#pragma -mark IMADDFriendsDelegate
-(void)addFriend:(UIButton *)sender andUserInfo:(IMUserModel *)model
{
    sender.userInteractionEnabled = NO;
    //接受好友请求
  //  AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *targetID = [DEFAULT objectForKey:@"userid"];
    NSString *hostName = [DEFAULT objectForKey:@"username"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?isAddFriend&isAddFir=agree&sourceUserId=%@&targetUserId=%@&targetUserName=%@&opration=accept",MAINURL,targetID,model.userId,hostName];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            NSInteger num = [resultBlock[@"code"] integerValue];
            if(num == 200)
            {
                //插入数据库
                //  [[MNDataBaseManager shareInstance]insertFriendToDB:_model];
                NSString *lastTime = resultBlock[@"lastAccessTime"];
                if(lastTime)
                {
                    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(thread1:) object:lastTime];
                    [thread1 start];
                }
                NSDictionary *userinfoDic = @{
                                              @"userName" : model.name,
                                              @"userImg" : model.portraitUri,
                                              @"status":@"1",
                                              @"userId":model.userId,
                                              @"message":model.message
                                              };
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:userinfoDic];
                [thread start];
                sender.backgroundColor = [UIColor whiteColor];
                [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [sender setTitle:ZGS(@"IMAdded") forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
                _dataArr = @[userinfoDic];
                [_tbView reloadData];
                
            }
            else
            {
                sender.userInteractionEnabled = YES;
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"IMFailed") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
                [alertView show];
                
            }
        }
        else
        {
            sender.userInteractionEnabled = YES;

        }
    }];
    
    
//    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//        NSLog(@"....%@",dict);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        sender.userInteractionEnabled = YES;
//    }];
}
-(void)thread:(id)obj
{
    //插入数据
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    [mutArr addObject:obj];
    [Tool writeToFile:mutArr withPath:@"friend"];
    //替换数据
    NSMutableArray *mutArr1 = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"requestFriend"]];
    for (int i = 0 ; i < mutArr1.count; i++) {
        NSDictionary *dict = mutArr1[i];
        if ([dict[@"userId"] isEqualToString:obj[@"userId"]]) {
            [mutArr1 replaceObjectAtIndex:i withObject:obj];
            break;
        }
    }
    [Tool writeToFile:mutArr1 withPath:@"requestFriend"];
}
-(void)thread1:(id)time
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    
    [mutDict setObject:time forKey:@"lastAccessTime"];
    [Tool writeToFile:mutDict withPath:@"time"];
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
