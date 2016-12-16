//
//  GestureTableViewController.m
//  MiningCircle
//
//  Created by ql on 15/11/16.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "GestureTableViewController.h"
#import "AppDelegate.h"
#import "Login1ViewController.h"
@interface GestureTableViewController () <UITableViewDataSource,UITableViewDelegate>
{
    int rowNum;
    NSArray *titleArr;
    NSArray *actArr;
    UITableViewCell *cell;
    NSArray *cellTitle;
    NSArray *cellType;
}
@end

@implementation GestureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-StatuesHeight-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSString* pswd = [LLLockPassword loadLockPassword];
    if (pswd) {
        cellTitle = @[ZGS(@"aGesture"),ZGS(@"cGesture")];
        cellType = @[@2,@3];
    } else {
        cellTitle = @[ZGS(@"sGesture")];
        cellType = @[@1];
    }
    [self changeFunc:cellTitle andtype:cellType];

    
    }
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userdefault = [NSUserDefaults new];
    int tag = [[userdefault objectForKey:@"succ"] intValue];
    if(tag == 1)
    {
        [self changeFunc:cellTitle andtype:cellType];
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"sign";
    cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    int type = [[actArr objectAtIndex:indexPath.row] intValue];
    [delegate showLLLockViewController:type];
    if(type == 1)
    {
        cellTitle = @[ZGS(@"aGesture"),ZGS(@"cGesture")];
        cellType = @[@2,@3];
    }
    else if(type == 3)
    {
        cellTitle = @[ZGS(@"sGesture")];
        cellType = @[@1];
    }
}
-(void)changeFunc:(NSArray *)title andtype:(NSArray *)type
{
    titleArr = title;
    actArr = type;
}


@end
