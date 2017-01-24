//
//  GroupListViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GroupListViewController.h"
#import "Tool.h"
#import "IMFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "IMRCChatViewController.h"
#import "RCIMDataSource.h"
#import "RCDUtilities.h"
@interface GroupListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@end

@implementation GroupListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //读数据
    UINib *nib = [UINib nibWithNibName:@"IMFriendTableViewCell" bundle:nil];
    [_tbView registerNib:nib forCellReuseIdentifier:@"Address"];
    _tbView.showsVerticalScrollIndicator = NO;
   // _tbView.pagingEnabled = YES;
  //  _tbView.bounces = NO;
    [self groupDataSource];
}
-(void)groupDataSource
{
    self.groupArr = [Tool readFileFromPath:@"groupInfo"];
    if(_groupArr.count == 0)
    {
        [RCDataSource getAddressBook:^(NSDictionary *addressDict) {
            _groupArr = addressDict[@"allGroup"];
            [_tbView reloadData];
        }];
    }
    [_tbView reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=  @"Address";
    IMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[IMFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    NSDictionary *dict = _groupArr[indexPath.row];
    cell.name.text = dict[@"groupName"];
    NSString *imgUrl = dict[@"groupImg"];
    if(imgUrl.length <= 0)
    {
        RCGroup *group = [[RCGroup alloc]init];
        group.groupId = dict[@"groupId"];
        group.groupName = dict[@"groupName"];
        imgUrl = [RCDUtilities defaultGroupPortrait:group];
    }
    NSURL *url = [NSURL URLWithString:imgUrl];
    [cell.headPortrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_group_portrait"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, 20)];
//    view.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 20)];
//    label.text = @"群聊";
//    label.textColor = RGB(150, 150, 150);
//    label.font = [UIFont systemFontOfSize:14];
//    [view addSubview:label];
//    return view;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _groupArr[indexPath.row];
    //跳转到群聊天
    IMRCChatViewController *chatVC = [[IMRCChatViewController alloc]init];
    chatVC.targetId =dict[@"groupId"];
    chatVC.title = dict[@"groupName"];
    chatVC.conversationType = ConversationType_GROUP;
    [self.navigationController pushViewController:chatVC animated:YES];
    
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
