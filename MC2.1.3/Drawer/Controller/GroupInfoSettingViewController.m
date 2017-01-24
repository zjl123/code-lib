//
//  GroupInfoSettingViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GroupInfoSettingViewController.h"
#import "GroupMemberCollectionViewCell.h"
#import "RCIMDataSource.h"
#import "HeaderCollectionReusableView.h"
#import "Tool.h"
#import "RCIMDataSource.h"
#import "FriendDetailViewController.h"
#import "IMAddFirendViewController.h"
#import "DataManager.h"
#import "SelectGroupMemberViewController.h"
#import "TwoLabelCollectionViewCell.h"
#import "middleTextCollectionViewCell.h"
#import "RemarkNameViewController.h"
#import "HudView.h"
#import "SwitchCollectionViewCell.h"
#import "PwdEdite.h"
#import "TYDecorationSectionLayout.h"
#import "ImgCollectionViewCell.h"
#import "CerateGroupViewController.h"
#define SwitchButtonTag  1111
@interface GroupInfoSettingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LogoutDelegate,SwitchDelegate,UIActionSheetDelegate,TransformValueDelegate,ProtrailDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)IMUserModel *myInfo;
@property (retain, nonatomic)NSMutableArray *addArr;
@property (nonatomic, retain)NSString *myUserId;
@end
@implementation GroupInfoSettingViewController
{
 //   NSMutableArray *memberArr;
    NSMutableArray *newMemberArr;
    NSArray *allFriendArr;
    NSArray *allRequestFriendArr;
    NSMutableArray *allInfoArr;
    dispatch_queue_t _quque;
    dispatch_queue_t _main;
    RCConversation *currentConversation;
    BOOL enableNotifiation;
    NSArray *sencendArr;
    BOOL isMine;
    //我在群成员列表显示的位置（为了修改昵称后刷新数据）
    int myIndex;
}

-(NSString *)myUserId
{
    if(!_myUserId)
    {
        _myUserId = [DEFAULT objectForKey:@"userid"];
    }
    return _myUserId;
}
-(NSMutableArray *)addArr
{
    if(!_addArr)
    {
        _addArr = [NSMutableArray array];
    }
    return _addArr;
}
-(IMUserModel *)myInfo
{
    if(!_myInfo)
    {
        NSString *userId = [DEFAULT objectForKey:@"userid"];
        for (NSDictionary *dict in self.memArr) {
            if([dict[@"userId"] isEqualToString:userId])
            {
                _myInfo = [[IMUserModel alloc]initWithDictionary:dict];
               // myInfo = _myInfo;
                
                break;
            }
    }

    }
    return _myInfo;
}
-(NSMutableArray *)memArr
{
    if(!_memArr)
    {
        _memArr = [NSMutableArray array];
        
    }
    return _memArr;
}
-(IMGroupModel *)groupModel
{
    if(!_groupModel)
    {
        NSArray *arr = [RCDataSource getAllGroupInfo];
        for (NSDictionary *dict in arr) {
            if([dict[@"groupId"] isEqualToString:self.groupId])
            {
                _groupModel = [[IMGroupModel alloc]initWithDictionary:dict];
                break;
            }
        }

    }
    return _groupModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.title = @"cdcdcd";
    myIndex = 0;
    allInfoArr = [NSMutableArray array];
    //更新数据
     [self getAllMemberShip];
    //加载数据
    [self loadData];
    TYDecorationSectionLayout *flouLayout = [[TYDecorationSectionLayout alloc]init];
    flouLayout.alternateDecorationViews = YES;
    flouLayout.decorationViewOfKinds = @[@"FirstDecorationSectionView"];
    
    flouLayout.minimumLineSpacing = 0.0f;
    flouLayout.minimumInteritemSpacing = 0.0f;
    flouLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flouLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.collectionViewLayout = flouLayout;
    _collectionView.pagingEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = RGB(237, 237, 237);
    _collectionView.tintColor = [UIColor whiteColor];
    [_collectionView registerClass:[GroupMemberCollectionViewCell class] forCellWithReuseIdentifier:@"member"];
    [_collectionView registerClass:[GroupMemberCollectionViewCell class] forCellWithReuseIdentifier:@"addOrDele"];
    [_collectionView registerClass:[TwoLabelCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    [_collectionView registerClass:[middleTextCollectionViewCell class] forCellWithReuseIdentifier:@"middle"];
    [_collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"potrail"];
    UINib *nib = [UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil];
    [_collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sheader"];
    [_collectionView registerClass:[SwitchCollectionViewCell class] forCellWithReuseIdentifier:@"switch"];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.groupModel = nil;
    [self startLoad];
   // [_collectionView reloadData];
}
-(void)startLoad
{
    currentConversation = [[RCIMClient sharedRCIMClient]getConversation:ConversationType_GROUP targetId:_groupId];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:_groupId success:^(RCConversationNotificationStatus nStatus) {
        enableNotifiation = NO;
        if(nStatus == NOTIFY)
        {
            enableNotifiation = YES;
        }
        [_collectionView reloadData];
    } error:^(RCErrorCode status) {
        
    }];
}
#pragma -mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        NSArray *arr = allInfoArr[section];
//        NSInteger num = arr.count;
//        if(num%4 != 0)
//        {
//            num =num - num%4 + 4;
//        }
        return arr.count;
    }
    else
    {
        NSArray *arr = allInfoArr[section];
        return arr.count;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return allInfoArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSDictionary *dict = self.memArr[indexPath.row];
        NSString *userId = dict[@"userId"];
        if(userId.length > 0)
        {
            GroupMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"member" forIndexPath:indexPath];
            cell.model = [[IMUserModel alloc]initWithDictionary:dict];
            if([cell.model.userId isEqualToString:self.myUserId])
            {
                myIndex = (int)indexPath.row;
            }
            return cell;
        }
        else
        {
            GroupMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addOrDele" forIndexPath:indexPath];
           // NSString *imgUrl = dict[@"userImg"];
            cell.model = [[IMUserModel alloc]initWithDictionary:dict];
            
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row < 2)
        {
            TwoLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
            NSDictionary *dict = allInfoArr[indexPath.section][indexPath.row];
            cell.title.text = dict[@"title"];
            cell.detail.text = dict[@"detail"];
            return cell;
        }
        else
        {
            ImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"potrail" forIndexPath:indexPath];
            NSDictionary *dict = allInfoArr[indexPath.section][indexPath.row];
            cell.info = dict;
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row != 2)
        {
            SwitchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"switch" forIndexPath:indexPath];
            cell.switchDelegate = self;
            cell.title.text = allInfoArr[indexPath.section][indexPath.row];
            cell.switch1.tag = SwitchButtonTag+indexPath.row;
            if(indexPath.row == 0)
            {
                cell.switch1.on = !enableNotifiation;
            }
            else if (indexPath.row == 1)
            {
                cell.switch1.on = currentConversation.isTop;
            }
            return cell;
        }
        else
        {
            TwoLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
            cell.title.text = allInfoArr[indexPath.section][indexPath.row];
            cell.detail.text = @"";
            return cell;
        }
    }
    else
    {
        //删除
        middleTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"middle" forIndexPath:indexPath];
        cell.logoutDelegate = self;
        NSString *str =allInfoArr[indexPath.section][indexPath.row];
        [cell.deleAndLogout setTitle:str forState:UIControlStateNormal];
        return cell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return CGSizeMake(70,82);
    }
    else if (indexPath.section == 1 )
    {
        if(indexPath.row < 2)
        {
            return CGSizeMake(collectionView.frame.size.width-20, 50);
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width-20, 60);
        }
    }
    else if (indexPath.section == 2)
    {
        return CGSizeMake(collectionView.frame.size.width-20, 50);
    }
    else
    {
        CGFloat cellHeight = 95;
        return CGSizeMake(collectionView.frame.size.width, cellHeight);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(width1, 20);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sheader" forIndexPath:indexPath];
    view.backgroundColor = RGB(237, 237, 237);
    view.editBtn.hidden = YES;
    view.title.hidden = YES;
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        GroupMemberCollectionViewCell *cell = (GroupMemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(self.groupModel.role == 2)
        {
            //群主
            if(indexPath.row < self.memArr.count -2)
            {
                //跳转到群成员详情
                
                NSArray *arr =[self getAllFriend];
                //  BOOL isContinut = YES;
                for (NSDictionary *dict in arr) {
                    if([dict[@"userId"] isEqualToString:cell.model.userId]||[cell.model.userId isEqualToString:[DEFAULT objectForKey:@"userid"]])
                    {
                        [self jumpToFriendDetail:cell.model];
                        return;
                    }
                }
                NSArray *requestFriend =[self getAllRequestFriend];
                for (NSDictionary *dict in requestFriend) {
                    if([dict[@"userId"]isEqualToString:cell.model.userId])
                    {
                        [self jumpToAddFriend:cell.model];
                        break;
                    
                    }
                }
                
                
            }
            else if (indexPath.row == self.memArr.count -2)
            {
                //加好友(跳转到好友列表添加)
                [self jumpToAllFriendList:self.groupModel];
                
            }
            else if(indexPath.row == self.memArr.count -1)
            {
                //删除好友(跳转到群成员列表删除)
                [self jumpToGroupMemberList:self.groupModel];
            }
        }
        else
        {//群成员
            if(indexPath.row < self.memArr.count -1)
            {
                //跳转到群成员详情
                GroupMemberCollectionViewCell *cell = (GroupMemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                NSArray *arr =[self getAllFriend];
                //  BOOL isContinut = YES;
                for (NSDictionary *dict in arr) {
                    if([dict[@"userId"] isEqualToString:cell.model.userId]||[cell.model.userId isEqualToString:[DEFAULT objectForKey:@"userid"]])
                    {
                        [self jumpToFriendDetail:cell.model];
                        return;
                    }
                }
                //不是好友
                [self jumpToAddFriend:cell.model];
                return;
                
            }
            else if(indexPath.row == self.memArr.count -1)
            {
                //加好友(跳转到好友列表添加)
                [self jumpToAllFriendList:self.groupModel];
                
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if(self.groupModel.role == 2)
        {
            if(indexPath.row == 0)
            {
                //修改群聊名称
                [self JumpToModifyGroupName];
            }
            else if (indexPath.row == 1)
            {
                //修改本人在群里的昵称
                [self JumpToModifyMyNameInGroup];
            }
            else if (indexPath.row == 2)
            {
                [self jumpToImg];
            }
        }
        else
        {
            //修改本人在群里的昵称
            [self JumpToModifyMyNameInGroup];
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row== 2)
        {
            //清除聊天记录
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:ZGS(@"IMDeleChatHis") delegate:self cancelButtonTitle:ZGS(@"cancle") destructiveButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
            actionSheet.tag = 100;
        }
    }
}
#pragma -mark 跳转到修改群聊名称
-(void)JumpToModifyGroupName
{
    RemarkNameViewController *remarkVC = [[RemarkNameViewController alloc]initWithNibName:@"RemarkNameViewController" bundle:nil];
    remarkVC.transDelegate = self;
    remarkVC.remarkTip = ZGS(@"IMGroupName");
    remarkVC.remarkFieldTip = self.groupModel.groupName;
    remarkVC.judgeStr = @"qun";
    remarkVC.userid = self.groupModel.groupId;
    isMine = NO;
    [self.navigationController pushViewController:remarkVC animated:YES];
}
/*
 *修改我在本群的昵称
 */
#pragma -mark 修改我在本群的昵称
-(void)JumpToModifyMyNameInGroup
{
    RemarkNameViewController *remarkVC = [[RemarkNameViewController alloc]initWithNibName:@"RemarkNameViewController" bundle:nil];
    remarkVC.transDelegate = self;
    remarkVC.remarkTip = ZGS(@"IMAliasInGroup");
    if(self.myInfo.remarksName.length > 0)
    {
        remarkVC.remarkFieldTip = self.myInfo.remarksName;
    }
    else
    {
        remarkVC.remarkFieldTip = self.myInfo.name;
    }
    remarkVC.judgeStr = @"myName";
    remarkVC.userid = self.groupModel.groupId;
    isMine = YES;
    [self.navigationController pushViewController:remarkVC animated:YES];
}
#pragma -mark 跳转修改群头像
-(void)jumpToImg
{
    CerateGroupViewController *create = [[CerateGroupViewController alloc]initWithNibName:@"CerateGroupViewController" bundle:nil];
    create.proDelegate = self;
    create.isCreate = NO;
    create.targetId = self.groupModel.groupId;
    [self.navigationController pushViewController:create animated:YES];
}
#pragma -mark 跳转到好友详情
-(void)jumpToFriendDetail:(IMUserModel *)model
{
    FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]initWithNibName:@"FriendDetailViewController" bundle:nil];
    friendDetail.model = model;
    [self.navigationController pushViewController:friendDetail animated:YES];
}
-(void)jumpToAddFriend:(IMUserModel *)model
{
    IMAddFirendViewController *addFriend = [[IMAddFirendViewController alloc]initWithNibName:@"IMAddFirendViewController" bundle:nil];
    addFriend.model = model;
   // addFriend.userID = model.userId;
    [self.navigationController pushViewController:addFriend animated:YES];
}
#pragma -mark 跳转到所有好友列表
-(void)jumpToAllFriendList:(IMGroupModel *)model
{
    //__block NSInteger maxNum ;
    [[RCIMDataSource shareInstance]getGroupInfoFromServer:model.groupId resultBlock:^(IMGroupModel *groupBlock) {
        NSInteger maxNum = groupBlock.maxNum;
        if(maxNum < 200)
        {
            //跳转到SelectGroupMemberViewController添加好友
            SelectGroupMemberViewController *selectMemeber = [[SelectGroupMemberViewController alloc]initWithNibName:@"SelectGroupMemberViewController" bundle:nil];
            selectMemeber.title = @"选择联系人";
            selectMemeber.isDele = NO;
            selectMemeber.groupModel = model;
            selectMemeber.groupMemberArr = self.memArr;
            selectMemeber.groupMaxNum = maxNum;
            [selectMemeber getBlock:^(NSDictionary *returnDict) {
                HudView *hudView = [[HudView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                hudView.time = 3.f;
                hudView.tipLabel.text = @"正在添加群成员";
                hudView.center = CGPointMake(width1/2, height1/3);
                [hudView.activity startAnimating];
                [self.view addSubview:hudView];
                
                [self addMemberInGroup:returnDict andHudView:hudView];
            }];
            [self.navigationController pushViewController:selectMemeber animated:YES];
        }
        else
        {
            [self showTip:@"群组成员已达上限"];
        }

    }];
}
#pragma -mark 跳转到所有成员列表
-(void)jumpToGroupMemberList:(IMGroupModel *)model
{
    SelectGroupMemberViewController *selectMemeber = [[SelectGroupMemberViewController alloc]initWithNibName:@"SelectGroupMemberViewController" bundle:nil];
    selectMemeber.title = @"聊天成员";
    selectMemeber.isDele = YES;
    selectMemeber.groupModel = model;
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.memArr];
    //移除加
    [newArr removeObjectAtIndex:newArr.count-2];
    //移除减
    [newArr removeObjectAtIndex:newArr.count-1];

    //移除自己
    [newArr removeObjectAtIndex:0];
    
    selectMemeber.groupMemberArr = newArr;
    [selectMemeber getBlock:^(NSDictionary *returnDict) {
        HudView *hudView = [[HudView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        hudView.tipLabel.text = @"正在删除群成员";
        hudView.center = CGPointMake(width1/2, height1/3);
        hudView.time = 3.0f;
        [self.view addSubview:hudView];
        
        [self deleMemberFromGroup:returnDict opration:@"Kicked" andHudView:hudView];
    }];
    [self.navigationController pushViewController:selectMemeber animated:YES];
}
#pragma -mark 退出群
-(void)deleSelfFromGroup
{
    NSString *name = [DEFAULT objectForKey:@"username"];
     NSString *parameterStr = [DEFAULT objectForKey:@"userid"];
    NSDictionary *dict = @{@"targetUserIds":@[parameterStr],@"targetUserDisplayNames":@[name],@"operatorNickname":name,@"newCreatorId":@""};
    [self deleMemberFromGroup:dict opration:@"Quit" andHudView:nil];
}
#pragma -mark 解散群
-(void)dismisGroup
{
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?dismissGroup&hostId=%@&groupId=%@&groupName=%@&opration=Dismiss",MAINURL,hostId,_groupId,self.groupModel.groupName];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *groupName = self.groupModel.groupName;
    NSDictionary *dict = @{@"operatorNickname":groupName};
    [[DataManager shareInstance]ConnectServer:getUrl parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            [[RCIMClient sharedRCIMClient]
             clearMessages:ConversationType_GROUP
             targetId:_groupId];
            
            [[RCIMClient sharedRCIMClient]
             removeConversation:ConversationType_GROUP
             targetId:_groupId];
            NSString *time = resultBlock[@"lastAccessTime"];
            if(time)
            {
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(writeTime:) object:time];
                [thread start];
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self showTip:@"解散失败"];
        }
    }];
    
    
//    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//        NSLog(@".......%@",dict);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}
-(void)writeTime:(NSString *)time
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    [mutDict setObject:time forKey:self.groupModel.groupId];
}
-(void)showTip:(NSString *)meassage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:meassage delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
    [alert show];
}
-(void)loadData
{
    NSArray *arr =  [RCDataSource getAllMembersFromLocalbyGroupId:_groupId];
    [self.memArr addObjectsFromArray:arr];
    self.memArr = [self moveCreaterToTheFirst:self.memArr];
    //增加加减
    [self DeleandAddData];
    //其他section
    if(self.memArr.count > 0)
    {
        [allInfoArr addObject:self.memArr];
    }
    else
    {
        [allInfoArr addObject:@[]];
    }
    NSString *userId = [DEFAULT objectForKey:@"userid"];
    __block NSString *name = @"";
    [RCDataSource getUserInfoWithUserId:userId inGroup:_groupId completion:^(RCUserInfo *userInfo) {
        name = userInfo.name;
    }];
    sencendArr = @[@{@"title":ZGS(@"IMAliasInGroup"),@"detail":name}];
    NSString *lastStr = ZGS(@"IMGroupLeave");
    if(self.groupModel.role == 2)
    {
        
        NSString *img = self.groupModel.portraitUri;
        img = [Tool judgeNil:img];
        lastStr = ZGS(@"IMGroupDissolve");
        sencendArr = @[@{@"title":ZGS(@"IMGroupName"),@"detail":self.groupModel.groupName},@{@"title":ZGS(@"IMAliasInGroup"),@"detail":name},@{@"title":@"群头像",@"detail":img}];
    }
    [allInfoArr addObject:sencendArr];
    NSArray *thirdArr = @[ZGS(@"IMNotifications"),ZGS(@"IMTop"),ZGS(@"IMClearHis")];
    [allInfoArr addObject:thirdArr];
    NSArray *lastArr = @[lastStr];
    [allInfoArr addObject:lastArr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}

#pragma -mark 更新数据
-(void)getAllMemberShip
{
    [RCDataSource getAllMembersOfGroup:_groupId result:^(NSArray<NSString *> *userIdList) {
        self.memArr = nil;
        [self.memArr addObjectsFromArray:userIdList];
        self.memArr = [self moveCreaterToTheFirst:self.memArr];
        //增加加减
        [self DeleandAddData];
        //其他section
        if(self.memArr.count > 0)
        {
          //  [allInfoArr insertObject:self.memArr atIndex:0];
            
            [allInfoArr replaceObjectAtIndex:0 withObject:self.memArr];
        }
       // [_collectionView reloadData];
        
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        //解决闪屏的问题
        [UIView performWithoutAnimation:^{
             [_collectionView reloadSections:indexSet];
        }];
       
 
    }];
}
-(void)DeleandAddData
{
    if (self.groupModel.role == 2) {
        //群主
        NSArray *arr = @[@{@"userImg":@"add_member"},@{@"userImg":@"delete_member"}];
        [self.memArr addObjectsFromArray:arr];
    }
    else
    {
        NSDictionary *dict = @{@"userImg":@"add_member"};
        [self.memArr addObject:dict];
    }
    //限制显示人数（50）
    [self limitDisplayMemberCount];
}
-(void)limitDisplayMemberCount
{
    if(self.memArr.count <= 50)
        return;
    NSRange range = NSMakeRange(50, self.memArr.count-50);
    [self.memArr removeObjectsInRange:range];
}
#pragma -mark 将群主移到第一个
-(NSMutableArray *)moveCreaterToTheFirst:(NSMutableArray *)groupMemberList
{
    if(groupMemberList == nil||groupMemberList.count == 0)
    {
        return nil;
    }
    for (int i = 0; i < groupMemberList.count; i++) {
        NSDictionary *dict = groupMemberList[i];
        if([dict[@"role"]integerValue] == 2)
        {
            [groupMemberList insertObject:dict atIndex:0];
            [groupMemberList removeObjectAtIndex:i+1];
            break;
        }
    }
    return groupMemberList;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)getAllFriend
{
    
    if(!allFriendArr)
    {
     allFriendArr = [RCDataSource getAllFriendInfo];
    }
    return allFriendArr;
}
-(NSArray *)getAllRequestFriend
{
    if(!allRequestFriendArr)
    {
        allRequestFriendArr = [RCDataSource getRequestFriendInfo];
    }
    return allRequestFriendArr;
}
#pragma -mark 加入群成员
-(void)addMemberInGroup:(NSDictionary *)usersDict andHudView:(HudView *)hud
{
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?joinGroup&groupId=%@&groupName=%@&sourceUserId=%@&opration=Add",MAINURL,self.groupModel.groupId,self.groupModel.groupName,hostId];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:usersDict];
    [mutDict setObject:usersDict forKey:@"data"];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:mutDict isPost:YES result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            [hud stopShow];
            [self refreshData:usersDict isAdd:YES];
            NSString *time = resultBlock[@"lastAccessTime"];
            if(time)
            {
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(writeTime:) object:time];
                [thread start];
            }
        }
        else
        {
            [self showTip];
        }
 
    }];
}
#pragma -mark 删除群成员（退出群）
-(void)deleMemberFromGroup:(NSDictionary *)usersDict opration:(NSString *)opration andHudView:(HudView *)hud
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?groupQuit&groupId=%@&opration=%@",MAINURL,self.groupModel.groupId,opration];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:usersDict];
    [mutDict setObject:usersDict forKey:@"data"];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:mutDict isPost:YES result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            [hud stopShow];
            [self refreshData:usersDict isAdd:NO];
            NSLog(@",,,,%@",resultBlock);
            NSString *time = resultBlock[@"lastAccessTime"];
            if(time)
            {
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(writeTime:) object:@""];
                [thread start];
            }
            if([opration isEqualToString:@"Quit"])
            {
                [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_GROUP targetId:_groupId];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else
        {
            [self showTip];
        }
 
    }];
}
-(void)refreshData:(NSDictionary *)info isAdd:(BOOL)add
{
    
    _quque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _main = dispatch_get_main_queue();
    dispatch_async(_quque, ^{
        if(!add)
        {
            NSArray *arr = info[@"targetUserIds"];
            for (NSString *userId in arr) {
                for (NSDictionary *dict in self.memArr) {
                    if([userId isEqualToString:dict[@"userId"]])
                    {
                       [self.memArr removeObject:dict];
                        //删除数据库的数据
                        NSThread *deleThread = [[NSThread alloc]initWithTarget:self selector:@selector(deleteThread:) object:arr];
                        [deleThread start];
                        break;
                    }
                }
            }
        }
        else
        {
           // NSArray *friendArr = [Tool readFileFromPath:@"friend"];
            NSArray *idArr = info[@"targetUserIds"];
            for (NSString *userId in idArr) {
                [[RCIMDataSource shareInstance]getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                    NSString *name = userInfo.name;
                    NSString *userImg = userInfo.portraitUri;
                    NSDictionary *newDict = @{@"userName":name,@"userId":userId,@"userImg":userImg,@"role":@"1"};
                    [self.addArr addObject:newDict];
                    [self.memArr insertObject:newDict atIndex:self.memArr.count-2];
                    
                }];
                
                
                
                
                
//                for (NSDictionary *dict in friendArr) {
//                  //  NSString *str = dict[@"userId"];
//                    if([userId isEqualToString:dict[@"userId"]])
//                    {
//                        NSString *userImg = dict[@"userImg"];
//                        
//                        if(!userImg||userImg.length <= 0)
//                        {
//                            userImg = @"";
//                        }
//                        NSString *name = dict[@"nameRemark"];
//                        if(name.length <= 0)
//                        {
//                            name = dict[@"userName"];
//                            name = [Tool judgeNil:name];
//                        }
//                        NSDictionary *newDict = @{@"userName":name,@"userId":dict[@"userId"],@"userImg":userImg,@"role":@"1"};
//                        [self.addArr addObject:newDict];
//                        [self.memArr insertObject:newDict atIndex:self.memArr.count-2];
//                       // [self.memArr addObject:newDict];
//                        break;
//                    }
//                }
            }
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(addThread:) object:self.addArr];
            [thread start];
          
        }
        dispatch_async(_main, ^{
            [allInfoArr replaceObjectAtIndex:0 withObject:self.memArr];
            NSLog(@"_memarr%@",self.memArr);
            NSLog(@"alll%@",allInfoArr);
            [_collectionView reloadData];
        });
    });
}
-(void)addThread:(NSMutableArray *)aArr
{
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:_groupId]];
    NSArray *arr = [NSArray arrayWithArray:aArr];
    for (NSDictionary *dict1 in arr) {
        for (NSDictionary *dict2 in mutArr) {
            if([dict1[@"userId"] isEqualToString:dict2[@"userId"]])
            {
                [aArr removeObject:dict1];
                break;
            }
        }
    }
    if(aArr.count > 0)
    {
        [mutArr addObjectsFromArray:aArr];
    }
    
}
-(void)deleteThread:(NSArray *)deleArr
{
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:_groupId]];
    for (NSString *userId in deleArr) {
        for (NSDictionary *dict in mutArr) {
            if([userId isEqualToString:dict[@"userId"]])
            {
                [mutArr removeObject:dict];
                break;
            }
        }
    }
    [Tool writeToFile:mutArr withPath:_groupId];
    
}
-(void)showTip
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败" delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma -mark TransformValueDelegate
-(void)transformValues:(NSString *)value
{
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:sencendArr];
    if(self.groupModel.role == 2)
    {
        if(isMine)
        {
            self.myInfo.remarksName = value;
            if(myIndex < self.memArr.count)
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.memArr[myIndex]];
                [dict setObject:value forKey:@"nameRemark"];
                [self.memArr replaceObjectAtIndex:myIndex withObject:dict];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:myIndex inSection:0];
                [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:mutArr[1]];
            [mutDict setObject:value forKey:@"detail"];
            [mutArr replaceObjectAtIndex:1 withObject:mutDict];
            [allInfoArr replaceObjectAtIndex:1 withObject:mutArr];
            
        }
        else
        {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:mutArr[1]];
            [mutDict setObject:value forKey:@"detail"];
            [mutArr replaceObjectAtIndex:0 withObject:mutDict];
            [allInfoArr replaceObjectAtIndex:1 withObject:mutArr];
        }
    }
    else
    {
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:mutArr[0]];
        [mutDict setObject:value forKey:@"detail"];
        [mutArr replaceObjectAtIndex:0 withObject:mutDict];
        [allInfoArr replaceObjectAtIndex:1 withObject:mutArr];
        
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [_collectionView reloadSections:indexSet];
}
#pragma -mark ProtrailDelegate
-(void)transProtrailUrl:(NSString *)protrailUrl
{
    NSThread *imgSave = [[NSThread alloc]initWithTarget:self selector:@selector(imgSave:) object:protrailUrl];
    [imgSave start];
//    sencendArr = @[@{@"title":ZGS(@"IMGroupName"),@"detail":self.groupModel.groupName},@{@"title":ZGS(@"IMAliasInGroup"),@"detail":name},@{@"title":@"群头像",@"detail":img}];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:sencendArr];
    NSDictionary *dict = @{@"title":@"群头像",@"detail":protrailUrl};
    [mutArr replaceObjectAtIndex:2 withObject:dict];
    [allInfoArr replaceObjectAtIndex:1 withObject:mutArr];
 //   NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
  //  [_collectionView reloadSections:indexSet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
-(void)imgSave:(NSString *)protrailUrl
{
    if(protrailUrl.length > 0 &&self.groupModel.groupId.length > 0)
    {
        NSString *name = self.groupModel.groupName;
        name = [Tool judgeNil:name];
        NSString *role = [NSString stringWithFormat:@"%ld",(long)self.groupModel.role];
        role = [Tool judgeNil:role];
        NSDictionary *dict = @{@"groupId":self.groupModel.groupId,@"groupImg":protrailUrl,@"groupName":name,@"role":role};
        [[RCIMDataSource shareInstance]saveGroupInfo:dict];
    }
}
#pragma -mark LogoutDelegate
-(void)LogoutGroup
{
    if(self.groupModel.role == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定要退出群组？" delegate:self cancelButtonTitle:ZGS(@"cancle") destructiveButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
        actionSheet.tag = 102;
        [actionSheet showInView:self.view];
        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定解散群组？" delegate:self cancelButtonTitle:ZGS(@"cancle") destructiveButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
        
        //        //解散
        //        [self dismisGroup];
    }
}

#pragma -mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100&&buttonIndex == 0)
    {
        [self clearMessage];
    }
    else if (actionSheet.tag == 101&&buttonIndex == 0)
    {
        [self dismisGroup];
    }
    else if (actionSheet.tag == 102&&buttonIndex == 0)
    {
        [self deleSelfFromGroup];
    }
}
-(void)clearMessage
{
    [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP targetId:_groupId success:^{
        NSLog(@"成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTip:@"清除聊天记录成功"];
            
        });
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistoryMsg" object:nil];
        
    } error:^(RCErrorCode status) {
        NSLog(@"失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTip:@"清除聊天记录失败"];
        });
        
    }];

}
#pragma -mark SwitchDelegate
-(void)onClick:(id)sender
{
    UISwitch *switchBtn = (UISwitch *)sender;
    if(switchBtn.tag == SwitchButtonTag)
    {
        //消息免打扰
        [self clickNotification:switchBtn];
    }
    else
    {
        //会话置顶
        [self clickIsTopBtn:switchBtn];
    }
}
//消息免打扰
-(void)clickNotification:(id)sender
{
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:_groupId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"成功");
        
    } error:^(RCErrorCode status) {
        NSLog(@"失败");
    }];
}
-(void)clickIsTopBtn:(UISwitch *)sender
{
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:_groupId isTop:sender.on];
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
