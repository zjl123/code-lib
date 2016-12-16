//
//  PrivateInfoSettingViewController.m
//  MiningCircle
//
//  Created by ql on 2016/11/3.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PrivateInfoSettingViewController.h"
#import "RCIMDataSource.h"
#import "SwitchCollectionViewCell.h"
#import "PriteInfoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "TwoLabelCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "Tool.h"
#define SWITCHTAG 200
@interface PrivateInfoSettingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SwitchDelegate,UIActionSheetDelegate>

@end

@implementation PrivateInfoSettingViewController
{
    IMUserModel *user;
    NSArray *dataArr;
    BOOL enableNotification;
    RCConversation *currentConversation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.pagingEnabled = NO;
    _collectionView.backgroundColor = RGB(237, 237, 237);
    
    [_collectionView registerClass:[SwitchCollectionViewCell class] forCellWithReuseIdentifier:@"switch"];
    [_collectionView registerClass:[PriteInfoCollectionViewCell class] forCellWithReuseIdentifier:@"info"];
    [_collectionView registerClass:[TwoLabelCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    [self startLoadView];
    [self loadData];
}
-(void)startLoadView
{
    currentConversation = [[RCIMClient sharedRCIMClient]getConversation:ConversationType_PRIVATE targetId:_userId];
    [[RCIMClient sharedRCIMClient]getConversationNotificationStatus:ConversationType_PRIVATE targetId:_userId success:^(RCConversationNotificationStatus nStatus) {
        enableNotification = NO;
        if(nStatus == NOTIFY)
        {
            enableNotification = YES;
        }
    } error:^(RCErrorCode status) {
        
    }];
}
-(void)loadData
{
     [RCDataSource getUserInfoWithUserId:_userId completion:^(RCUserInfo *userInfo) {
         NSString *name = userInfo.name;
         name = [Tool judgeNil:name];
         NSString *userId = userInfo.userId;
         userId = [Tool judgeNil:userId];
         NSString *imgUrl = userInfo.portraitUri;
         imgUrl = [Tool judgeNil:imgUrl];
         NSDictionary *dict = @{@"userName":name,@"userImg":imgUrl,@"userId":userId};
         user = [[IMUserModel alloc]initWithDictionary:dict];
    }];
    dataArr = @[@"消息免打扰",@"会话置顶",@"清空聊天记录"];
   [_collectionView reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return CGSizeMake(width1, 88);
    }
    else
    {
        return CGSizeMake(width1, 50);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return dataArr.count;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(width1, 20);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        PriteInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"info" forIndexPath:indexPath];
        [cell.potrail sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
        if(user.remarksName.length > 0)
        {
            cell.label1.hidden = NO;
            cell.label2.hidden = YES;
            cell.label3.hidden = NO;
            cell.label1.text = user.remarksName;
            cell.label3.text = user.name;
        }
        else
        {
            cell.label1.hidden = YES;
            cell.label2.hidden = NO;
            cell.label3.hidden = YES;
            cell.label2.text = user.name;
        }
        return cell;
    }
    else
    {
        if(indexPath.row != 2)
        {
            SwitchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"switch" forIndexPath:indexPath];
            cell.title.text = dataArr[indexPath.row];
            cell.switchDelegate = self;
            cell.switch1.tag = SWITCHTAG +indexPath.row;
            if(indexPath.row == 0)
            {
                cell.switch1.on = !enableNotification;
            }
            else
            {
                cell.switch1.on = currentConversation.isTop;
            }
            return cell;
        }
        else
        {
            TwoLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
            cell.title.text = dataArr[indexPath.row];
            cell.detail.text = @"";
            return cell;

        }
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == 2)
        {
            //清除消息记录
            //清除聊天记录
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定清除消息记录？" delegate:self cancelButtonTitle:ZGS(@"cancle") destructiveButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
            actionSheet.tag = 100;
        }
    }
}
#pragma -mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE targetId:_userId success:^{
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
}
-(void)showTip:(NSString *)meassage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:meassage delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
    [alert show];
}
//消息免打扰
-(void)clickNotification:(id)sender
{
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE targetId:_userId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"成功");
        
    } error:^(RCErrorCode status) {
        NSLog(@"失败");
    }];
}
-(void)clickIsTopBtn:(UISwitch *)sender
{
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:_userId isTop:sender.on];
}

-(void)onClick:(id)sender
{
    UISwitch *swch = (UISwitch *)sender;
    if(swch.tag == SWITCHTAG)
    {
        //消息免打扰
         [self clickNotification:swch];
    }
    else
    {
        //会话置顶
        [self clickIsTopBtn:swch];
    }
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
