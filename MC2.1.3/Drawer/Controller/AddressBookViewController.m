//
//  AddressBookViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/19.
//  Copyright © 2016年 zjl. All rights reserved.
//  通讯录

#import "AddressBookViewController.h"
#import "IMFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import "Tool.h"
#import "FriendDetailViewController.h"
#import "IMUserModel.h"
#import "GroupListViewController.h"
#import "NewFriendsViewController.h"
#import "RCIMDataSource.h"
#import "MobileContactViewController.h"
@interface AddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,FreshDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbVIew;

@end

@implementation AddressBookViewController
{
    NSArray *resultArr;
    //排序后的字典({@"tag":tagArr,@"sec":resultArr}),其中tagArr是字母
    NSDictionary *resultDict;
    //排序后的数据源
    NSArray *sortedArr;
    NSArray *letterArr;
    BOOL refresh;
    //section1数据源
    NSArray *section1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"IMFriendTableViewCell" bundle:nil];
    [_tbVIew registerNib:nib forCellReuseIdentifier:@"Address"];
    //获取好友数据
    
    [self getAllFriendsInfoFromServer];
    section1= @[@{@"img":@"newfriend",@"title":ZGS(@"IMNewFriend")},@{@"img":@"groups",@"title":ZGS(@"IMGroup")},@{@"img":@"groups",@"title":ZGS(@"IMMobile")}];
    refresh = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(refresh == YES)
    {
        [self getAllFriendFromLocal];
    }
}
#pragma -mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section != 0)
    {
    NSArray *arr = sortedArr[section-1];
    return arr.count;
    }
    else
    {
        return section1.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  sortedArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=  @"Address";
    IMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[IMFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if(indexPath.section == 0)
    {
        NSDictionary *dict = section1[indexPath.row];
        cell.name.text = dict[@"title"];
        cell.headPortrait.image = [UIImage imageNamed:dict[@"img"]];
    }
    else
    {
        NSDictionary *dict = sortedArr[indexPath.section-1][indexPath.row];
        cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    }

    return cell;

}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 20.f;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
    return 30.f;
    }
    else
    {
        return 0.f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // if(section != 0)
   // {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, 30)];
        view.backgroundColor = RGB(240, 240, 240);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 22, 30)];
        label.text = letterArr[section-1];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB(150, 150, 150);
        [view addSubview:label];
        return view;
    //}
}
#pragma -mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //新朋友
            NewFriendsViewController *newFriend = [[NewFriendsViewController alloc]initWithNibName:@"NewFriendsViewController" bundle:nil];
            newFriend.dataArr = [Tool readFileFromPath:@"requestFriend"];
            [self.navigationController pushViewController:newFriend animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //群聊
            GroupListViewController *groupList = [[GroupListViewController alloc]initWithNibName:@"GroupListViewController" bundle:nil];
            [self.navigationController pushViewController:groupList animated:YES];
        }
        else if(indexPath.row == 2)
        {
            //手机联系人
            MobileContactViewController *mobileContact = [[MobileContactViewController alloc]init];
            [self.navigationController pushViewController:mobileContact animated:YES];
            
        }
    }
    else
    {
        //跳转朋友详情
        FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]initWithNibName:@"FriendDetailViewController" bundle:nil];
        friendDetail.freshDelegate = self;
        NSDictionary *dict = sortedArr[indexPath.section-1][indexPath.row];
        friendDetail.model = [[IMUserModel alloc]initWithDictionary:dict];
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
}
-(void)refresh:(BOOL)isRefresh andNewData:(id)newData
{
    if(newData)
    {
        resultArr = newData;
        [self sorted];
    }
    else
    {
        refresh = isRefresh;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllFriendFromLocal
{
    resultArr = [RCDataSource getAllFriendInfo];
    [self sorted];
}
#pragma -mark 从服务器获取全部好友
-(void)getAllFriendsInfoFromServer
{
    [RCDataSource getAddressBook:^(NSDictionary *addressDict) {
        resultArr = addressDict[@"allFriend"];
        if(resultArr.count <= 0)
        {
            resultArr = [Tool readFileFromPath:@"friend"];
        }
        [self sorted];
    }];
    
    
}
#pragma -mark 按字母排序
-(void)sorted
{
    resultDict = [Tool sort:resultArr sortKey:@"userName"];
    sortedArr = resultDict[@"sec"];
    letterArr = resultDict[@"tag"];
    [_tbVIew reloadData];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}


//表格右侧添加A-Z索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return letterArr;
}
//索引cell关联
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [letterArr indexOfObject:title];
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
