//
//  IMSearchFriendViewController.m
//  MiningCircle
//
//  Created by ql on 16/10/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "IMSearchFriendViewController.h"
#import "IMFriendTableViewCell.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "FriendDetailViewController.h"
#import "IMAddFirendViewController.h"
#import "IMUserModel.h"
#import "Tool.h"
#import "PwdEdite.h"
@interface IMSearchFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@end

@implementation IMSearchFriendViewController
{
    //搜索结果
    NSArray *resultArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"IMFriendTableViewCell" bundle:nil];
    [_tbView registerNib:nib forCellReuseIdentifier:@"IMFriend"];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *str = searchBar.text;
    if(str.length > 0)
    {
        [self getInfo:str];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=  @"IMFriend";
    IMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[IMFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    NSDictionary *dict = resultArr[indexPath.row];
    cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //已经是好友跳转到详细资料里，不是好友跳转到添加好友里
    NSDictionary *dict = resultArr[indexPath.row];
    NSString *userid = dict[@"userId"];
    //查找是否是好友
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    BOOL isFriend = NO;
    for (NSDictionary *dict in mutArr) {
       if([dict[@"userId"] isEqualToString:userid])
       {
           isFriend = YES;
           break;
       }
    }
    if(isFriend)
    {
        //跳转到FriendDetailViewController
        FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]initWithNibName:@"FriendDetailViewController" bundle:nil];
        friendDetail.model = [[IMUserModel alloc]initWithDictionary:dict];
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
    else
    {
        IMAddFirendViewController *addFriend = [[IMAddFirendViewController alloc]initWithNibName:@"IMAddFirendViewController" bundle:nil];
        addFriend.model = [[IMUserModel alloc]initWithDictionary:dict];
        
        [self.navigationController pushViewController:addFriend animated:YES];

    }
}
#pragma -mark 查找好友
-(void)getInfo:(NSString *)friendName
{
    //AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findFriend&userName=%@",MAINURL,friendName];
   getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        
        resultArr = resultBlock[@"friends"];
        if(resultArr.count > 0)
        {
            _tbView.hidden = NO;
            [_tbView reloadData];
        }
        else
        {
            _tbView.hidden = YES;
        }

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

@end
