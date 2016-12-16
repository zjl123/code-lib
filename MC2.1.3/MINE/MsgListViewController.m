//
//  MsgListViewController.m
//  MiningCircle
//
//  Created by ql on 15/12/15.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "MsgListViewController.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Exten.h"
#import "NSString+Exten.h"
#define originalHeight 75.0f
//#define newHeight 100.0f
//#define isOpen @"85.0f"
#import "ImgButton.h"
@interface MsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *cellArr;
    CGFloat cellHeight;
   // NSMutableArray *mutHeight;
   // CGFloat hhh;
    UIView *footView;
}
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@end

@implementation MsgListViewController
{
    NSInteger count;
    CGFloat mHeight;
    NSInteger sectionIndex;
    NSMutableArray *showArr;
    CGFloat footHeight;
  //  NSMutableArray *deleteArr;
    BOOL isEdting;
    BOOL isTotal;
    NSMutableArray *heightArr;
    NSMutableIndexSet *mutIndexSet;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //编辑按钮
    ImgButton *btn = [ImgButton buttonWithType:UIButtonTypeCustom];
    //btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize btnSize = [ZGS(@"cancle") getStringSize:[UIFont systemFontOfSize:18] width:100];
    btn.frame = CGRectMake(0, 0, btnSize.width, 32);
    [btn setTitle:ZGS(@"edit") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitle:ZGS(@"cancle") forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title = ZGS(@"messageHis");
    count = 0;
    mHeight = originalHeight;
    sectionIndex = 0;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tbView.autoresizesSubviews = YES;
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@/msg.plist",pathsandox,userid];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:newPath];
    cellArr = [[NSMutableArray alloc]initWithArray:arr];
    //高度数组
    heightArr = [NSMutableArray array];
    for (int i = 0; i < cellArr.count; i++) {
        [heightArr addObject:@75];
        
    }
    if(cellArr.count > 0)
    {
        UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [_tbView registerNib:nib forCellReuseIdentifier:@"msgCell"];
        showArr = [NSMutableArray array];
        for (int i = 0; i <cellArr.count; i++) {
            NSString *tag = @"NO";
            [showArr addObject:tag];
        }
    }
    else
    {
        [self hidden];
    }
    footHeight = 0;
  //  deleteArr = [NSMutableArray array];
    mutIndexSet = [NSMutableIndexSet indexSet];
    isEdting = NO;
    isTotal = NO;
}
-(void)hidden
{
    _tbView.hidden = YES;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, height1/3, width1-40, 50)];
    lable.text = ZGS(@"noMessage");
    lable.textAlignment = NSTextAlignmentCenter;
    lable.minimumScaleFactor = 0.5;
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = RGB(120, 120, 120);
    [self.view addSubview:lable];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",pathsandox,userid];
    //写入plist文件
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@/msg.plist",pathsandox,userid];
    if ([cellArr writeToFile:plistPath atomically:YES]) {
        NSLog(@"写入成功");
    };
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)editClick:(ImgButton *)btn
{
    //static int num = 1;
    //if(num == 1)
    //{
         [self deleteView];
    //}
    //num++;
    isEdting = !isEdting;
    btn.selected = isEdting;
    [_tbView setEditing:isEdting];
    if(isEdting)
    {
        //高度
        
        
        
        
        //动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.1f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCATransitionFromRight;
        [footView.layer addAnimation:animation forKey:@"animation"];
        footView.hidden = NO;
    }
    else
    {
      //  footHeight = 0;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.1f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCATransitionFromRight;
        [footView.layer addAnimation:animation forKey:@"animation"];
        footView.hidden = YES;
        [mutIndexSet removeAllIndexes];
    }
    [_tbView reloadData];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(cellArr.count == 0)
    {
        [self hidden];
    }
    return cellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
////////////////////////////////////////////////////////////
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil];
    TableViewCell *cell = [nib objectAtIndex:0];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = cellArr[indexPath.row];
    cell.title.text = dict[@"title"];
    NSString *content = dict[@"content"];
    cell.detail.text = content;
    cell.detail.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    if([showArr[indexPath.row] isEqualToString:@"Yes"])
    {
        cell.detail.numberOfLines = 0;
    }
    else
    {
        cell.detail.numberOfLines = 1;
    }
    NSString *str = dict[@"ico"];
    NSURL *url = [NSURL URLWithString:str];
    [cell.img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    NSNumber  *time = dict[@"time"] ;
    long long t = [time longLongValue];
    cell.time.text = [self getState:t];
    NSString *tag = dict[@"tag"];
    if([tag isEqualToString:@"0"])
    {
        cell.redPoint.hidden = YES;
        cell.title.textColor = RGB(180, 180, 180);
        cell.detail.textColor = RGB(180, 180, 180);
        cell.time.textColor = RGB(180, 180, 180);
    }
    
    return cell;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
#pragma -mark deleteView
-(void)deleteView
{
    if(!footView)
    {
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, height1-50-self.navigationController.navigationBar.frame.size.height-StatuesHeight, width1, 50)];
    footView.backgroundColor = RGB(255, 255, 192);
    [self.view addSubview:footView];
    //删除按钮
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize deleSize = [ZGS(@"delete") getStringSize:[UIFont systemFontOfSize:18] width:width1/2];
    deleBtn.frame = CGRectMake(width1-deleSize.width-10, 10, deleSize.width, 30);
    [deleBtn setTitle:ZGS(@"delete") forState:UIControlStateNormal];
    [deleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:deleBtn];
    //全选按钮
    ImgButton *totalBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
    CGSize totalSize = [ZGS(@"totalSel") getStringSize:[UIFont systemFontOfSize:18] width:width1/2];
    totalBtn.frame = CGRectMake(10, 10, totalSize.width, 30);
        totalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [totalBtn setTitle:ZGS(@"totalSel") forState:UIControlStateNormal];
    [totalBtn setTitle:ZGS(@"cancle") forState:UIControlStateSelected];
    [totalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalSelected:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:totalBtn];
    }
}
-(void)totalSelected:(UIButton *)btn
{
    isTotal = !isTotal;
    btn.selected = isTotal;
    if(btn.selected)
    {
        
        NSLog(@"全选");
        //全选
        for (int row = 0; row < cellArr.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            [_tbView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [mutIndexSet addIndex:row];
        }
    //    [deleteArr addObjectsFromArray:cellArr];
        
    }
    else
    {
        //取消
        NSLog(@"取消");
        for (int row = 0; row < cellArr.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            [_tbView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        [mutIndexSet removeAllIndexes];
       // [deleteArr removeAllObjects];
    }
}
-(void)deleClick:(UIButton *)btn
{
    NSLog(@"删除");
    if(mutIndexSet.count > 0)
    {
        [cellArr removeObjectsAtIndexes:mutIndexSet];
        [showArr removeObjectsAtIndexes:mutIndexSet];
        [heightArr removeObjectsAtIndexes:mutIndexSet];
        footHeight = 0;
        ImgButton *imgBtn = self.navigationItem.rightBarButtonItem.customView;
        [self editClick:imgBtn];

        [_tbView reloadData];
        [mutIndexSet removeAllIndexes];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.editing)
    {
     //   TableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];

        [mutIndexSet addIndex:indexPath.row];
      //  NSLog(@"vvvv%f",targetCell.detail.frame.size.width);
    }
    else
    {
        TableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        // NSLog(@"vvvvv%f",targetCell.detail.frame.size.width);
        targetCell.selected = YES;
        if (targetCell.frame.size.height == originalHeight){
            CGSize size = [targetCell.detail.text getStringSize:[UIFont systemFontOfSize:15] width:targetCell.detail.frame.size.width];
            
            CGFloat hhh=originalHeight + size.height-18;
            NSNumber *num = [NSNumber numberWithFloat:hhh];
            [heightArr replaceObjectAtIndex:indexPath.row withObject:num];
            [showArr replaceObjectAtIndex:indexPath.row withObject:@"Yes"];
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[cellArr objectAtIndex:indexPath.row]];
            [mutDict setObject:@"0" forKey:@"tag"];
            [cellArr replaceObjectAtIndex:indexPath.row withObject:mutDict];
        }
        else{
                NSNumber *num = [NSNumber numberWithFloat:originalHeight];
                [heightArr replaceObjectAtIndex:indexPath.row withObject:num];
                [showArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];

        }
    //刷新单行
        [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
 
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.editing)
    {
        [mutIndexSet removeIndex:indexPath.row];

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightArr[indexPath.row] floatValue];
}

//转换时间
-(NSString *)getState:(long long)time
{
    NSTimeInterval t = time/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationDateStr = [dateformatter stringFromDate:date];
    return locationDateStr;
}
//删除
#pragma -mark 返回指定行编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [heightArr replaceObjectAtIndex:indexPath.row withObject:@88];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
