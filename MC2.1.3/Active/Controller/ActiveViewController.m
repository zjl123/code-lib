//
//  ActiveViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/30.
//  Copyright (c) 2015年 zjl. All rights reserved.
//
#import "ActiveViewController.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "MJRefresh.h"
#import "Login1ViewController.h"
#import "BannerDetailViewController.h"
//#import "WebViewController.h"
#import "Tool.h"
#import "BgImgButton.h"
#import "IMSearchFriendViewController.h"
#import "RCDChatListCell.h"
#import "IMUserModel.h"
#import "NewFriendsViewController.h"
#import "AddTableViewCell.h"
#import "ActSubTbVIew.h"
#import "AddressBookViewController.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import "SelectGroupMemberViewController.h"
#import "IMRCChatViewController.h"
#import "AppDelegate.h"
#import "RCDCustomerServiceViewController.h"
#define SERVICE_ID @"KEFU147851385519595"

@interface ActiveViewController () <UIWebViewDelegate,UIGestureRecognizerDelegate,JumpDelegate,UIAlertViewDelegate>
{
    
    NSArray *bannerArr;
    NSMutableArray *listArr;
    NSMutableDictionary *listParamesdictParams;
    NSDictionary *dictParams;
    NSMutableDictionary *listDict;
    NSDictionary *kuangDict;
    int page;
    //弹出菜单
    ActSubTbVIew *tbView;
    //弹出菜单背景
    UIView *bgView;
    //提醒登陆
    UILabel *tipLabel ;
    UIView *tipBgView;
    
    UIButton *backBtn;
}
@property (nonatomic, retain) NSArray *tbArr;
@end

@implementation ActiveViewController


-(instancetype)init
{
    self = [super init];
    if(self)
    {
        //设置需要显示的哪些类型的会话
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_SYSTEM),@(ConversationType_PUSHSERVICE),@(ConversationType_GROUP),@(ConversationType_CUSTOMERSERVICE)]];
        //设置需要将那些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_PUSHSERVICE)]];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBar.topItem.title = @"";
     self.navigationItem.hidesBackButton = YES;
    if(self.navigationController.viewControllers.count > 1)
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        backBtn.frame = CGRectMake(7, 4, 35, 36);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [backBtn addTarget:self action:@selector(leftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:backBtn];
    }
    
    
    
    
    self.conversationListTableView.dataSource  = self;
      self.showConnectingStatusOnNavigatorBar = YES;
  //  self.isShowNetworkIndicatorView = NO;
    BgImgButton *btn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:888];
 //   btn.hidden = YES;
    [btn removeFromSuperview];
    BgImgButton *btn1 = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
    [btn1 removeFromSuperview];
    
    //单聊
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"thin_add"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //注册cell
    UINib *nib1 = [UINib nibWithNibName:@"RCDChatListCell" bundle:nil];
    [self.conversationListTableView registerNib:nib1 forCellReuseIdentifier:@"RCD1"];
    self.tbArr = @[@{@"title":ZGS(@"IMAddF"),@"ico":@"addFriend"},@{@"title":ZGS(@"IMContacts"),@"ico":@"addressBook"},@{@"title":ZGS(@"IMCreateG"),@"ico":@"group"}];
    
    self.navigationController.navigationBarHidden = NO;
  //  [self judgeCustomService];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    backBtn.hidden = NO;
    //判断登陆
    if ([DEFAULT integerForKey:@"login"] == 0) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"unLog") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"login"), nil];
        [alter show];
    }
    
    
    NSInteger num = [DEFAULT integerForKey:@"login"];
    if(num == 1)
    {
        if(tipBgView)
        {
            [tipBgView removeFromSuperview];
            tipBgView = nil;
        }
         [self refreshConversationTableViewIfNeeded];
      //  [self.conversationListTableView reloadData];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    backBtn.hidden = YES;
}
-(void)leftBtnclick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)judgeCustomService
//{
//    //判断是否有客服会话，没有插入
//    NSLog(@",,,,,,%d",self.conversationListDataSource.count);
//    RCInformationNotificationMessage *content = [RCInformationNotificationMessage notificationWithMessage:ZGS(@"IMStart") extra:nil];
//   int num = [[RCIMClient sharedRCIMClient]getMessageCount:ConversationType_CUSTOMERSERVICE targetId:SERVICE_ID];
//    if(num <= 0)
//    {
//        [[RCIMClient sharedRCIMClient]insertOutgoingMessage:ConversationType_CUSTOMERSERVICE targetId:SERVICE_ID sentStatus:SentStatus_SENDING content:content];
//    }
//    //置顶
//    [[RCIMClient sharedRCIMClient]setConversationToTop:ConversationType_CUSTOMERSERVICE targetId:SERVICE_ID isTop:YES];
//}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == 0)
//    {
//        return NO;
//    }
//    return YES;
//}
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == 0)
//    {
//        RCConversationCell *conCell = (RCConversationCell *)cell;
//        if(conCell.model.conversationType == ConversationType_CUSTOMERSERVICE)
//        {
//            [conCell setEditingAccessoryType:UITableViewCellAccessoryNone];
//        }
//    }
//}
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            }
        if ([model.lastestMessage
             isKindOfClass:[RCGroupNotificationMessage class]]) {
            RCGroupNotificationMessage *groupNotification =
            (RCGroupNotificationMessage *)model.lastestMessage;
            if ([groupNotification.operation isEqualToString:@"Quit"]) {
                NSData *jsonData =
                [groupNotification.data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization
                                            JSONObjectWithData:jsonData
                                            options:NSJSONReadingMutableContainers
                                            error:nil];
                NSDictionary *data =
                [dictionary[@"data"] isKindOfClass:[NSDictionary class]]
                ? dictionary[@"data"]
                : nil;
                NSString *nickName =
                [data[@"operatorNickname"] isKindOfClass:[NSString class]]
                ? data[@"operatorNickname"]
                : nil;
                if ([nickName isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
                    [[RCIMClient sharedRCIMClient]
                     removeConversation:model.conversationType
                     targetId:model.targetId];
                    [self refreshConversationTableViewIfNeeded];
                }
            }
        }
    }
    
    return dataSource;

}
-(void)rightClick:(UIButton *)sender
{
    //弹出菜单
    [self setUpTbView:sender];
    
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMRCChatViewController *conversationVC = [[IMRCChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    if(conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE )
    {
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    if(conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL)
    {
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        conversationVC.unReadMessage = model.unreadMessageCount;
        conversationVC.enableNewComingMessageIcon = YES;
        conversationVC.enableUnreadMessageIcon = YES;
        if(model.conversationType == ConversationType_SYSTEM)
        {
            conversationVC.title = ZGS(@"IMSystemMsg");
        }
        if([model.objectName isEqualToString:@"RC:ContactNtf"])
        {
            NewFriendsViewController *newFriends = [[NewFriendsViewController alloc]initWithNibName:@"NewFriendsViewController" bundle:nil];
            newFriends.needSyncFriendList = YES;
            [self.navigationController pushViewController:newFriends animated:YES];
            return;
        }
        //如果单聊，不显示发送方昵称
//        if(model.conversationType == ConversationType_PRIVATE)
//        {
//            conversationVC.displayUserNameInCell = NO;
//        }
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    if(conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION)
    {
        ActiveViewController *temp = [[ActiveViewController alloc]init];
        NSArray *arr = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:arr];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //自定义会话类型
    if(conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION)
    {
        RCConversationModel *model =   self.conversationListDataSource[indexPath.row];
        if([model.objectName isEqualToString:@"RC:ContactNtf"])
        {
            NewFriendsViewController *newFriends = [[NewFriendsViewController alloc]initWithNibName:@"NewFriendsViewController" bundle:nil];
            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            NSDictionary *userInfo ;//= [DEFAULT objectForKey:_contactNotificationMsg.sourceUserId];
            //读取数据
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"requestFriend"]];
            for (NSDictionary *dict in mutArr) {
                if([dict[@"userId"] isEqualToString:_contactNotificationMsg.sourceUserId])
                {
                    userInfo = dict;
                }
            }
            
            if(userInfo.count > 0)
            {
                newFriends.dataArr = @[userInfo];
                
            }
            [self.navigationController pushViewController:newFriends animated:YES];
        }
        
    }
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       [self refreshConversationTableViewIfNeeded];
                   });
    
}


//*********************插入自定义Cell*********************//

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0f;
}

//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
    
    __weak ActiveViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                RCContactNotificationMessage *_contactNotificationMsg =
                (RCContactNotificationMessage *)model.lastestMessage;
                if (_contactNotificationMsg.sourceUserId == nil) {
                    RCDChatListCell *cell =
                    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@""];
                    cell.lblDetail.text = @"好友请求";
                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                                  placeholderImage:[UIImage imageNamed:@"contact"]];
                    return cell;
                }
                NSDictionary *_cache_userinfo;
                NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"requestFriend"]];
                for (NSDictionary *dict in mutArr) {
                    if([dict[@"userId"] isEqualToString:_contactNotificationMsg.sourceUserId])
                    {
                        _cache_userinfo = dict;
                        break;
                    }
                }
                
                
                if (_cache_userinfo.count > 0) {
                    userName = _cache_userinfo[@"userName"];
                    portraitUri = _cache_userinfo[@"userImg"];
                } else {
                    NSDictionary *emptyDic = @{};
                    [[NSUserDefaults standardUserDefaults]
                     setObject:emptyDic
                     forKey:_contactNotificationMsg.sourceUserId];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //请求
                   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
                    //查找好友（根据id）
                    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findFriend&userId=%@",MAINURL,_contactNotificationMsg.sourceUserId];
                    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
                       
                        NSArray *arr = resultBlock[@"friends"];
                        if(arr.count > 0)
                        {
                            NSDictionary *dict1 = arr[0];
                            if(dict1.count > 0)
                            {
                                IMUserModel *rcduserinfo_ = [IMUserModel new];
                                NSString *name = dict1[@"userName"];
                                name = [Tool judgeNil:name];
                                rcduserinfo_.name = name ;
                                rcduserinfo_.userId = _contactNotificationMsg.sourceUserId;
                                NSString *imgUrl = dict1[@"userImg"];
                                imgUrl = [Tool judgeNil:imgUrl];
                                rcduserinfo_.portraitUri = imgUrl ;
                                
                                model.extend = rcduserinfo_;
                                NSString *sourceid = _contactNotificationMsg.sourceUserId;
                                sourceid = [Tool judgeNil:sourceid];
                                NSString *message = _contactNotificationMsg.message;
                                message = [Tool judgeNil:message];
                                // local cache for userInfo
                                NSString *userStatue = @"2" ;
                                if([_contactNotificationMsg.operation isEqualToString:@"accept"])
                                {
                                    userStatue = @"1";
                                }
                                
                                NSDictionary *userinfoDic = @{
                                                              @"userName" : rcduserinfo_.name,
                                                              @"userImg" : rcduserinfo_.portraitUri,
                                                              @"status":userStatue,
                                                              @"userId":sourceid,
                                                              @"message":message
                                                              };
                                
                                
                                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadWrite:) object:userinfoDic];
                                [thread start];
                                [weakSelf.conversationListTableView
                                 reloadRowsAtIndexPaths:@[ indexPath ]
                                 withRowAnimation:
                                 UITableViewRowAnimationAutomatic];
                                
                            }
                        }

                    }];
                }
            }
        
    } else {
        IMUserModel *user = (IMUserModel *)model.extend;
        userName = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell =
    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@""];
    cell.lblDetail.text =
    [NSString stringWithFormat:@"来自%@的好友请求", userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                  placeholderImage:[UIImage imageNamed:@"contact"]];
    cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
    cell.model = model;
    return cell;
}

//*********************插入自定义Cell*********************//

#pragma -mark 弹出菜单
-(void)setUpTbView:(UIButton *)sender
{
    if(!tbView)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        /////////////////////////////////////////////
        [self.tabBarController.view insertSubview:bgView belowSubview:sender];
        tbView = [[ActSubTbVIew alloc]initWithFrame:CGRectMake(width1*2/3-30,20+self.navigationController.navigationBar.frame.size.height, width1/3+30, self.tbArr.count*44) style:UITableViewStylePlain];
        tbView.jumpDelegate = self;
        tbView.tbArr = _tbArr;
        tbView.hidden = YES;
        [bgView addSubview:tbView];
        
    }
    sender.selected = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    [tbView.layer addAnimation:animation forKey:@"animation"];
    bgView.hidden = NO;
    tbView.hidden = NO;
    [tbView reloadData];
    
    
}
-(void)tapBg:(UITapGestureRecognizer *)tapGesture
{
    tapGesture.view.hidden = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    animation.subtype = kCATransitionReveal;
    [tbView.layer addAnimation:animation forKey:@"animation"];
    tbView.hidden = YES;
}
#pragma -mark JumpDelegate
-(void)jumpTo:(NSInteger)tag
{
    if(tag == 0)
    {
        //添加
        IMSearchFriendViewController *searchCV = [[IMSearchFriendViewController alloc]initWithNibName:@"IMSearchFriendViewController" bundle:nil];
        [self.navigationController pushViewController:searchCV animated:YES];
    }
    else if (tag == 1)
    {
        //通讯录
        AddressBookViewController *addressVC = [[AddressBookViewController alloc]initWithNibName:@"AddressBookViewController" bundle:nil];
        [self.navigationController pushViewController:addressVC animated:YES];
        
    }
    else if (tag == 2)
    {
        //创建群组
        SelectGroupMemberViewController *selectGroup = [[SelectGroupMemberViewController alloc]initWithNibName:@"SelectGroupMemberViewController" bundle:nil];
        selectGroup.title = ZGS(@"IMCreateG");
        [self.navigationController pushViewController:selectGroup animated:YES];
        
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // NSLog(@"%@",[touch.view.superview class]);
    // NSLog(@"%@",[gestureRecognizer.view class]);
    //截获手势（解决手势冲突问题）
    if([touch.view.superview isKindOfClass:[UITableViewCell class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}
#pragma -mark 提现登陆
-(void)tipLogin
{
    if(!tipBgView)
    {
        tipBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, self.conversationListTableView.frame.size.height)];
        tipBgView.backgroundColor = [RGB(250, 250, 250)colorWithAlphaComponent:0.9];
        tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (height1-self.navigationController.navigationBar.bounds.size.height-StatuesHeight-self.tabBarController.tabBar.bounds.size.height)/2-50, width1-40, 40)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = RGB(100, 100, 100);
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.text = ZGS(@"cartLog");
        CGFloat tipLabelMaxY = CGRectGetMaxY(tipLabel.frame);
        [tipBgView addSubview:tipLabel];
        //登录按钮
        ImgButton *logBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
        logBtn.backgroundColor = MAINCOLOR;
        logBtn.layer.cornerRadius = 1;
        CGSize logSize =  [ZGS(@"gotoLog") getStringSize:[UIFont systemFontOfSize:17] width:width1];
        logBtn.frame = CGRectMake((width1-logSize.width-16)/2, tipLabelMaxY+3, logSize.width+20, 35);
        logBtn.layer.cornerRadius = 4;
        [logBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        logBtn.title = ZGS(@"gotoLog");
        logBtn.normalColor = [UIColor whiteColor];
        [tipBgView addSubview:logBtn];
        [self.view addSubview:tipBgView];
    }
}
-(void)loginClick:(ImgButton *)sender
{
    [self gotoLogin];
}
-(void)gotoLogin
{
    Login1ViewController *login = [[Login1ViewController alloc]initWithNibName:@"Login1ViewController" bundle:nil
                                   ];
    
    [self.navigationController pushViewController:login animated:YES];
    
    //    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.myTabBar.customTabBar btnClick:delegate.myTabBar.customTabBar.tabBarButtons[4]];
}
#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self gotoLogin];
    }
    else
    {
        [self tipLogin];
    }
}
//新朋友存取
-(void)threadWrite:(NSDictionary *)dict
{

    if([dict[@"status"] isEqualToString:@"1"])
    {
        //存入friend
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray: [Tool readFileFromPath:@"friend"]];
        [mutArr addObject:dict];
        //写入
        [Tool writeToFile:mutArr withPath:@"friend"];
        //存入requestFriend
        //读取
        NSMutableArray *mutArr1 = [NSMutableArray arrayWithArray: [Tool readFileFromPath:@"requestFriend"]];
        [mutArr1 addObject:dict];
        //写入
        [Tool writeToFile:mutArr1 withPath:@"requestFriend"];

    }
    else if ([dict[@"status"] isEqualToString:@"2"])
    {
        //存入requestFriend
        //读取
       NSMutableArray *mutArr = [NSMutableArray arrayWithArray: [Tool readFileFromPath:@"requestFriend"]];
        [mutArr addObject:dict];
        //写入
        [Tool writeToFile:mutArr withPath:@"requestFriend"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)vcResponse:(NSNotification *)n
//{
//
//    NSDictionary *dict = [n object];
//    if(dict.count > 0)
//    {
//        NSString *str = [dict objectForKey:@"login"];
//        NSArray *msg = [dict objectForKey:@"msg"];
//        if ([str isEqualToString:@"web"])
//        {
//            //        [self setUpKuangYeYi];
//            //        [self refreshWeb];
//        }
//        else if ([str isEqualToString:@"login"])
//        {
//            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
//            if(!aBtn)
//            {
//                aBtn = [self.tabBarController.view viewWithTag:654];
//            }
//            UIView *redView = [aBtn viewWithTag:777];
//            if(msg.count > 0)
//            {
//                redView.hidden = NO;
//            }
//            else
//            {
//                redView.hidden = YES;
//            }
//        }
//        else
//        {
//            static int a = 0;
//            //   NSLog(@"base11111%d",a);
//            //  NSLog(@"CONTROLLER%@",self);
//            a++;
//            //logo
//#if KGOLD
//            BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
//            lbtn.bgImg = dict[@"applogol"];
//            //搜索
//            BgImgButton *sBtn = [self.navigationController.navigationBar viewWithTag:889];
//            sBtn.bgImg = dict[@"seach"];
//            //加号
//            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
//            aBtn.bgImg = dict[@"pull"];
//#elif KMIN
//            BgImgButton *lbtn = (BgImgButton *)[self.navigationController.navigationBar viewWithTag:890];
//            lbtn.bgImg = dict[@"pull"];
//            //搜索
//            // BgImgButton *sBtn = [self.navigationController.navigationBar viewWithTag:889];
//            // sBtn.bgImg = dict[@"seach"];
//            //加号
//            BgImgButton *aBtn = [self.navigationController.navigationBar viewWithTag:888];
//            aBtn.bgImg = dict[@"msgico"];
//
//#endif
//        }
//    }
//
//}
@end
