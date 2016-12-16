//
//  LinkmanTableViewController.m
//  MiningCircle
//
//  Created by ql on 15/12/24.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "LinkmanTableViewController.h"
#import "LinkmanTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "DataManager.h"
#import "PwdEdite.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "EditeMessageViewController.h"
#import "ImgButton.h"
@interface LinkmanTableViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation LinkmanTableViewController
{
  //  NSArray *linkmanArr;
    NSMutableArray *addPhoneNum;
    NSMutableArray *addName;
    BOOL isEditing;
    GreyView *greyView;
    ActivityView *actView;
    dispatch_queue_t _queue;
    dispatch_queue_t _main;
}
//-(NSArray *)firstArr
//{
//    if(!_firstArr)
//    {
//        _firstArr = [NSArray array];
//        //self.firstArr = _firstArr;
//    }
//    return _firstArr;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnclick:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    ImgButton *rightBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:ZGS(@"edit") forState:UIControlStateNormal];
    [rightBtn setTitle:ZGS(@"done") forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = rightItem;
    UINib *nib = [UINib nibWithNibName:@"LinkmanTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"linkman"];
        addPhoneNum = [NSMutableArray array];
    addName = [NSMutableArray array];
    isEditing = NO;
    [self activity];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPhoneBooks];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_linkArr.count > 0)
    {
        [self.tableView reloadData];
        [self activityStopShow];
    }
}

-(void)getPhoneBooks
{
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _main = dispatch_get_main_queue();
    dispatch_async(_queue, ^{
        self.firstArr = [Tool getAddressBook];
        NSDictionary *resultDict = [Tool sort:self.firstArr sortKey:@"userName"];
        [self activityStopShow];
        _linkArr = resultDict[@"sec"];
        _tagArr = resultDict[@"tag"];
        dispatch_async(_main, ^{
            if(self.firstArr.count > 0)
            {
                [self.tableView reloadData];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"getFailed") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                [alertView show];
            }
        });
         });
}
-(void)activity
{
    greyView = [[GreyView alloc]init];
    greyView.frame = CGRectMake(0, 0, 80, 80);
    greyView.center = CGPointMake(width1/2, height1/2-80);
    [self.view addSubview:greyView];
    
    actView = [[ActivityView alloc]init];
    actView.frame = CGRectMake(0, 0, 50, 50);
    actView.center = greyView.center;
    [self.view addSubview:actView];
    [actView startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(activityStopShow) userInfo:nil repeats:NO];
}
-(void)activityStopShow
{
    
    if(greyView != nil)
    {
        [actView stopAnimating];
        [greyView removeFromSuperview];
        actView = nil;
        greyView = nil;
    }
}



-(void)leftBtnclick:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
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
       if(_paramsArr.count > 5)
       {
        int type = [_paramsArr[3] intValue];
        NSString *content = _paramsArr[5];
      //  content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if(type == 0)
        {
            //调用发短信见面
            [self showMessageView:addPhoneNum title:@"" body:content];
        }else
        {
            //跳转到显示页面
            
            //[self postToService];
            if(_paramsArr.count > 7)
            {
                NSString *content = _paramsArr[5];
                NSString *url = _paramsArr[7];
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self jump:addPhoneNum NameArr:addName Url:url andContent:content];
            }
        }
       }

        
    }
}
-(void)jump:(NSArray *)phoneArr NameArr:(NSArray *)nameArr Url:(NSString *)url andContent:(NSString *)content
{
    EditeMessageViewController *edit = [[EditeMessageViewController alloc]initWithNibName:@"EditeMessageViewController" bundle:nil];
    edit.phoneArr = phoneArr;
    edit.nameArr = nameArr;
    edit.urlStr = url;
    edit.msg = content;

    [self.navigationController pushViewController:edit animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"countcount%lu",(unsigned long)_linkArr.count);
   
    NSArray *arr = _linkArr[section];
    return arr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _linkArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LinkmanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linkman"];
    NSDictionary *dict = _linkArr[indexPath.section][indexPath.row];
    cell.name.text = dict[@"userName"];
    cell.phoneNum.text = dict[@"phoneNum"];
    return cell;
    
}
//表格右侧添加A-Z的索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *mutArr = [NSMutableArray array];
//     [mutArr addObject:@"#"];
//    for (int i = 'A'; i <='Z'; i++) {
//        [mutArr addObject:[NSString stringWithFormat:@"%c",i]];
//    }
    return _tagArr;
}
//索引于cell关联
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_tagArr indexOfObject:title];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
//编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(tableView.isEditing)
   {
       LinkmanTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       NSString *name = cell.name.text;
       NSString *phoneNum = cell.phoneNum.text;
       
       //NSDictionary *dict = @{@"name":name,@"phoneNum":phoneNum};
       [addPhoneNum addObject:phoneNum];
       [addName addObject:name];
   }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LinkmanTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [addPhoneNum removeObject:cell.phoneNum.text];
    [addName removeObject:cell.name.text];
}

#pragma -mark MFMessageComposeViewControllerDelegate
//回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //
            break;
        case MessageComposeResultFailed:
            //
            break;
        case MessageComposeResultCancelled:
           // NSLog(@"cvcvcvcvccvcvcvvc");
            //
            break;
        default:
            break;
    }
}
/*
 *发短信
 */
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc]init];
        smsController.recipients = phones;
        smsController.body = body;
        smsController.title = title;
        self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
        smsController.messageComposeDelegate = self;
        [self presentViewController:smsController animated:YES completion:nil];
        [[[[smsController viewControllers] lastObject] navigationItem] setTitle:title];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZGS(@"tipMessage")
                                                        message:ZGS(@"messageFunc")
                                                       delegate:nil
                                              cancelButtonTitle:ZGS(@"ok")
                                              otherButtonTitles:nil, nil];
        [alert show];
    
    }
}
/*
// Override to support conditional rearranging of the table view.

*/


@end
