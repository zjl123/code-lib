//
//  MobileContactViewController.m
//  MiningCircle
//
//  Created by ql on 2016/11/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "MobileContactViewController.h"
#import "NewFriendTableViewCell.h"
#import "DataManager.h"
#import "PwdEdite.h"
@interface MobileContactViewController ()<IMAddFriendsDelegate>
@property (nonatomic, strong) NSMutableArray *seleArr;
@end

@implementation MobileContactViewController
-(NSMutableArray *)seleArr
{
    if(!_seleArr)
    {
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"NewFriendTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"mobileContact"];
    
    
}
-(void)postFromMobileContact
{
    NSString *userId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findUserByPhone&userId=%@",MAINURL,userId];
    NSDictionary *paramers = @{@"phoneNums":self.firstArr};
    [[DataManager shareInstance]ConnectServer:getUrl parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        NSArray *arr = resultBlock[@"listPhone"];
        if(arr.count > 0)
        {
            [self getNewDate:arr];
        }
    }];
}
-(void)getNewDate:(NSArray *)array
{
    dispatch_queue_t _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t _main = dispatch_get_main_queue();
    dispatch_async(_queue, ^{
        NSDictionary *dict = [Tool sort:array sortKey:@"userName"];
        self.linkArr = dict[@"sec"];
        self.tagArr = dict[@"tag"];
        if(self.linkArr.count > 0)
        {
            dispatch_async(_main, ^{
                [self.tableView reloadData];
                
            });
        }
    });
}
-(void)postFriendData
{
    
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?dealPhoneFriend",MAINURL];
    if(self.seleArr.count > 0)
    {
    NSDictionary *dict = @{@"firendsInfos":self.seleArr};
    [[DataManager shareInstance]ConnectServer:getUrl parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
        NSLog(@"...%@",resultBlock);
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"sendSuc") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"sendFailed") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    self.seleArr = nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mobileContact"];
    cell.addFriendDelegate = self;
    NSDictionary *dict = self.linkArr[indexPath.section][indexPath.row];
    cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    cell.statues = dict[@"status"];
    NSDictionary *info = dict[@"info"];
    if(info.count > 0)
    {
        cell.model.userId = info[@"userId"];
    }
    if(tableView.editing)
    {
        cell.btn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if([cell.statues isEqualToString:@"1"])
        {
            cell.selected = YES;
            cell.highlighted = YES;
            cell.tintColor = [UIColor redColor];
            cell.userInteractionEnabled = NO;
        }
        else
        {
          //  cell.btn.hidden = NO;
            cell.selected = NO;
            cell.tintColor = [UIColor blueColor];
            cell.userInteractionEnabled = YES;
        }
        
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btn.hidden = NO;
        cell.selected = NO;
        cell.tintColor = [UIColor blueColor];
        cell.userInteractionEnabled = YES;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.linkArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.linkArr[section];
    return arr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.isEditing)
    {
        NewFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *phoneNum = cell.detail.text;
        NSString *status = cell.statues;
       status =  [Tool judgeNil:status];
        NSString *userId = cell.model.userId;
        userId = [Tool judgeNil:userId];
        NSDictionary *newDict;
        if(phoneNum.length > 0)
        {
            newDict = @{@"phoneNum":phoneNum,@"status":status,@"userId":userId};
            [self.seleArr addObject:newDict];
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *arr = [NSArray arrayWithArray:self.seleArr];
    for (NSDictionary *dict in arr) {
        if([dict[@"phoneNum"] isEqualToString:cell.detail.text])
        {
            [self.seleArr removeObject:dict];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark IMAddFriendsDelegate
-(void)addFriend:(UIButton *)sender andUserInfo:(IMUserModel *)model
{
    //邀请
    NSString *phoneNum = model.phoneNum;
    NSString *status = model.status;
    status =  [Tool judgeNil:status];
    NSString *userId = model.userId;
    userId = [Tool judgeNil:userId];
    NSDictionary *newDict;
    if(phoneNum.length > 0)
    {
        newDict = @{@"phoneNum":phoneNum,@"status":status,@"userId":userId};
        [self.seleArr addObject:newDict];
        [self postFriendData];
    }

}
-(void)rightBtnClick:(UIButton *)item
{
    
    isEditing = !isEditing;
    if(isEditing)
    {
        item.selected = YES;
    }
    else
    {
        item.selected = NO;
    }
    [self.tableView setEditing:isEditing];
    if(!isEditing)
    {
        [self.tableView reloadData];
        //提交到服务器
        if(self.seleArr.count > 0)
        {
            [self postFriendData];
        }
    }
    else
    {
        [self.tableView reloadData];
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
