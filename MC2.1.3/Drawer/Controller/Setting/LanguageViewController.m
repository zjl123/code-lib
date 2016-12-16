//
//  LanguageViewController.m
//  MiningCircle
//
//  Created by ql on 16/8/18.
//  Copyright © 2016年 zjl. All rights reserved.
//

#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"languageset"


#import "LanguageViewController.h"
#import "Tool.h"
#import "ImgButton.h"

@interface LanguageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)NSArray *titleArr;
@property (nonatomic,retain)NSArray *enTitle;
@end

@implementation LanguageViewController
{
    UIView *hudView;
    ImgButton *saveBtn;
    int tag;
    int tag1;
    NSString *lang;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //保存按钮
    saveBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 50, 32);
    saveBtn.title = ZGS(@"save");
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    saveBtn.normalColor = RGB(200, 200, 200);
    saveBtn.userInteractionEnabled = NO;
    [saveBtn addTarget:self action:@selector(saveLang:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self getLang];
    
}
-(void)saveLang:(ImgButton *)sender
{
    [[FGLanguageTool sharedInstance] setNewLanguage:lang];
}
-(NSArray *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = @[@"简体中文",@"English"];
    }
    return _titleArr;
}
-(NSArray *)enTitle
{
    if(_enTitle == nil)
    {
        _enTitle = @[CNS,EN];
    }
    return _enTitle;
}
-(void)getLang
{
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    if(!str)
    {
        str = [Tool getPreferredLanguage];
    }
    if([str rangeOfString:@"en"].location != NSNotFound)
    {
        tag = 1;
    }
    else
    {
        tag = 0;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"lang";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    NSString *title
    = _titleArr[indexPath.row];
    if(tag == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        tag1 = tag;
    }
    cell.textLabel.text = title;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //高亮
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row != tag)
    {
        saveBtn.normalColor = [UIColor whiteColor];
        saveBtn.userInteractionEnabled = YES;
    }
    else
    {
        saveBtn.normalColor = RGB(200, 200, 200);
        saveBtn.userInteractionEnabled = NO;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:tag1 inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    tag1 = (int)indexPath.row;
    lang = self.enTitle[indexPath.row];

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
