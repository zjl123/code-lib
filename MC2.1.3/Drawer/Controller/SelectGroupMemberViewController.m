//
//  SelectGroupMemberViewController.m
//  MiningCircle
//
//  Created by ql on 2016/10/24.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SelectGroupMemberViewController.h"
#import "Tool.h"
#import "IMFriendTableViewCell.h"
#import "CerateGroupViewController.h"
#import "DataManager.h"
#import "RCIMDataSource.h"
#import "PwdEdite.h"
@interface SelectGroupMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (retain, nonatomic) NSMutableArray *useridArr;
@property (retain, nonatomic)NSMutableArray *userNameArr;
@end

@implementation SelectGroupMemberViewController
{
    NSArray *friendArr;
    NSArray *letterArr;
    UIButton *rightBtn;
}
////懒加载
//-(NSMutableArray *)useridArr
//{
//    if(_useridArr == nil)
//    {
//        _useridArr = [NSMutableArray array];
//    }
//    return _useridArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 //   self.title = @"创建群组";
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    rightBtn.layer.cornerRadius = 3;
    NSString *str = ZGS(@"ok");
    if(_groupModel.groupId.length > 0)
    {
        if(_isDele)
        {
            str = ZGS(@"delete");
            [rightBtn setBackgroundColor:RGB(162, 63, 64)];
            [rightBtn setTitleColor:RGB(182, 107, 107) forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    [rightBtn setTitle:str forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    _useridArr = [NSMutableArray array];
    _userNameArr = [NSMutableArray array];
    UINib *nib = [UINib nibWithNibName:@"IMFriendTableViewCell" bundle:nil];
    [_tbView registerNib:nib forCellReuseIdentifier:@"Address"];
    _tbView.editing = YES;
    [self tableviewData];
}
#pragma -mark 确定
-(void)doneClick:(UIButton *)sender
{
    if(_groupModel.groupId.length > 0)
    {
      __block  NSString *hostNameInGroup = [DEFAULT objectForKey:@"username"];
        if(_userNameArr.count > 0 &&_useridArr.count > 0)
        {
            NSDictionary *dict = @{@"operatorNickname":hostNameInGroup,@"targetUserIds":_useridArr,@"targetUserDisplayNames":_userNameArr};
                self.returnBlock(dict);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        CerateGroupViewController *createGroup = [[CerateGroupViewController alloc]initWithNibName:@"CerateGroupViewController" bundle:nil];
        createGroup.isCreate = YES;
        createGroup.useridArr = _useridArr;
        [self.navigationController pushViewController:createGroup animated:YES];
    }
}
-(void)addMemberInGroup
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?joinGroup&groupId=%@&groupName=%@&sourceUserId=%@&opration=addMember",MAINURL,_groupModel.groupId,_groupModel.groupName,hostId];
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //数组变字符串

    NSString *parameterStr = [_useridArr componentsJoinedByString:@","];
    parameterStr = [parameterStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    parameterStr = [Tool judgeNil:parameterStr];
    NSDictionary *paramers = @{@"targetUserId":parameterStr};
    
    [[DataManager shareInstance]ConnectServer:getUrl parameters:paramers isPost:NO result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            NSLog(@",,,,%@",resultBlock);
            NSString *time = resultBlock[@"lastAccessTime"];
            if(time)
            {
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(writeTime:) object:time];
                [thread start];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showTip:@"操作失败"];
        }

    }];
}

-(void)deleMemberFromGroup
{
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?groupQuit&groupId=%@&opration=deleMember",MAINURL,_groupModel.groupId];
   getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //数组变字符串
    NSString *parameterStr = [_useridArr componentsJoinedByString:@","];
    parameterStr = [Tool judgeNil:parameterStr];
   parameterStr = [parameterStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramers = @{@"quitUserId":parameterStr};
    
    [[DataManager shareInstance]ConnectServer:getUrl parameters:paramers isPost:NO result:^(NSDictionary *resultBlock) {
        if([resultBlock[@"code"] integerValue] == 200)
        {
            NSLog(@",,,,%@",resultBlock);
            NSString *time = resultBlock[@"lastAccessTime"];
            if(time)
            {
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(writeTime:) object:time];
                [thread start];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showTip:@"操作失败"];
        }

    }];
}
-(void)getBlock:(ReturnDataBlock)block
{
    self.returnBlock = block;
}
-(void)showTip:(NSString *)tipStr
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:tipStr delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)writeTime:(NSString *)time
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    [mutDict setObject:time forKey:_groupModel.groupId];
}
-(void)tableviewData
{
    if(_groupModel.groupId.length > 0)
    {
        if(_isDele)
        {
           // NSArray *arr = [Tool readFileFromPath:_groupModel.groupId];
            friendArr = @[_groupMemberArr];
        }
        else
        {
            NSArray *arr = [Tool readFileFromPath:@"friend"];
            friendArr = @[arr];
        }
    }
    else
    {
        //读
        NSArray *arr = [Tool readFileFromPath:@"friend"];
        //排序
        NSDictionary *dict = [Tool sort:arr sortKey:@"userName"];
        friendArr = dict[@"sec"];
        letterArr = dict[@"tag"];
    }
    [_tbView reloadData];
    
}
#pragma -mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return friendArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = friendArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=  @"Address";
    IMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[IMFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    NSDictionary *dict = friendArr[indexPath.section][indexPath.row];
    cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    cell.selected = NO;
    cell.tintColor = [UIColor blueColor];
    cell.userInteractionEnabled = YES;
    if(!_isDele&&_groupModel.groupId.length > 0)
    {
        for (NSDictionary *memberDict in _groupMemberArr) {
            if([memberDict[@"userId"] isEqualToString:dict[@"userId"]])
            {
                cell.selected = YES;
                cell.tintColor = [UIColor lightGrayColor];
                cell.userInteractionEnabled = NO;
                break;
            }
        }
    }
        return cell;

}
#pragma -mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, 30)];
    view.backgroundColor = RGB(240, 240, 240);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 22, 30)];
    label.text = letterArr[section];
    label.textColor = RGB(150, 150, 150);
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    return view;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.isEditing)
    {
        NSInteger mxNum1 = self.groupMaxNum+_useridArr.count;
        if(mxNum1 < 200)
        {
            IMFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [_useridArr addObject:cell.model.userId];
            [_userNameArr addObject:cell.model.name];
            NSInteger mxNum = self.groupMaxNum+_useridArr.count;
            if(mxNum == 200)
            {
             //   cell.selected = NO;
                [self showTip:@"群成员人数已达上限"];
               // [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
            }
            if(_groupModel.groupId.length > 0)
            {
                if(_useridArr.count > 0&&_isDele)
                {
                    [rightBtn setBackgroundColor:[UIColor redColor]];
                    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            IMFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selected = NO;
            [self showTip:@"群成员人数已达上限"];
        }
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.isEditing)
    {
        IMFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [_useridArr removeObject:cell.model.userId];
        //为了取到备注名
        [_userNameArr removeObject:cell.name.text];
        if(_groupModel.groupId.length > 0)
        {
            if(_useridArr.count == 0&&_isDele)
            {
                [rightBtn setBackgroundColor:RGB(162, 63, 64)];
                [rightBtn setTitleColor:RGB(182, 107, 107) forState:UIControlStateNormal];
            }
        }
    }
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
