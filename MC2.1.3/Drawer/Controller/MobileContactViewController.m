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

@end

@implementation MobileContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"NewFriendTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"mobileContact"];
    
}
//-(void)
-(void)postFromMobileContact
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *userId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findUserByPhone&userId=%@",MAINURL,userId];
    NSDictionary *paramers = @{@"phoneNums":self.firstArr};
    [[DataManager shareInstance]ConnectServer:getUrl parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        NSArray *arr = resultBlock[@"listPhone"];
        NSLog(@"^^^^^%@",arr);
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mobileContact"];
    cell.addFriendDelegate = self;
    NSDictionary *dict = self.linkArr[indexPath.section][indexPath.row];
    cell.model = [[IMUserModel alloc]initWithDictionary:dict];
    cell.statues = @"0";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark IMAddFriendsDelegate
-(void)addFriend:(UIButton *)sender andUserInfo:(IMUserModel *)model
{
    //邀请
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
