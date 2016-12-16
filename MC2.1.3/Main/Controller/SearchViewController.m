//
//  SearchViewController.m
//  MiningCircle
//
//  Created by ql on 16/7/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SearchViewController.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
#import "SearchCollectionViewCell.h"
#import "SearchView.h"
#import "BannerDetailViewController.h"
#import "SearchWebViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
@interface SearchViewController ()<UITextFieldDelegate,SearchDelegate,UIAlertViewDelegate>

@end

@implementation SearchViewController
{
    UICollectionView *colView;
    CGFloat hotY;
    CGFloat hotMaxY;
    SearchView *searchView;
  //  UILabel *hotLabel;
   // NSArray *hotArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView)
    {
        searchView.delegate = self;
        [searchView changeFrame];
        searchView.controller = self.navigationController;
    }
    UILabel *hisLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, 200, 20)];
    hisLabel.text = ZGS(@"hisSearch");
    hisLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:hisLabel];
    //删除
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateSelected];
    delBtn.frame = CGRectMake(width1-30, 20, 20, 20);
    [self.view addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delClick:) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *hisArr = [userDefault objectForKey:@"searchHistory"];
    [self setUpButtons:hisArr :CGRectGetMaxY(hisLabel.frame)+10];
    [self receivedHotWords];
    UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, hotY, 100, 20)];
    hotLabel.text = ZGS(@"hotSearch");
    hotMaxY = CGRectGetMaxY(hotLabel.frame);
    [self.view addSubview:hotLabel];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    searchView.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchView rollBack];

}
-(void)delClick:(UIButton *)sender
{
//    NSUserDefaults *userDefault = [NSUserDefaults new];
//    NSArray *hisArr = [userDefault objectForKey:@"searchHistory"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"deleHis") delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
    [alertView show];
}
-(void)receivedHotWords
{
    NSDictionary *paramers = @{@"cmd":@"keywords",@"os":@"iOS"};
   // dict = [PwdEdite ecoding:dict];
  //  AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
   
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        if(resultBlock.count > 0)
        {
           // NSDictionary *result = [PwdEdite decoding:dict];
            NSArray *hotArr = resultBlock[@"phrase"];
            [self setUpButtons:hotArr :hotMaxY+10];
        }

    }];
    
    
//    [manager POST:STRURL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}
-(void)setUpButtons:(NSArray *)titleArr :(CGFloat)orignalY
{
    CGFloat x = 12;
    int i = 0;
    for (NSString *name in titleArr) {
        ImgButton *btn = [ImgButton buttonWithType:UIButtonTypeCustom];
        btn.title = name;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = RGB(241, 241, 241);
        btn.normalColor = RGB(156, 159, 163);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [name getStringSize:[UIFont systemFontOfSize:12] width:width1-20];
        CGFloat w = size.width+40;
        if(x + w +10 > width1)
        {
            x = 12;
            orignalY = orignalY +30;
            i++;
            if(i >= 3)
            {
                orignalY = orignalY - 30;
                break;
            }
        }
        btn.frame = CGRectMake(x, orignalY, w, 25);
        [self.view addSubview:btn];
        x = CGRectGetMaxX(btn.frame)+5;
    }
    hotY = orignalY +25+20;
}
-(void)btnCLick:(ImgButton *)sender
{
    [self jumpToDetail:sender.titleLabel.text];
}
#pragma -mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(searchView)
    {
        [searchView.searchField resignFirstResponder];
    }
}
#pragma -mark SearchDelegate
-(void)jumpSearchList:(NSString *)keyWord
{
    [self jumpToDetail:keyWord];
}
-(void)jumpSearch
{
    
}
-(void)jumpToDetail:(NSString *)keyWord
{
    SearchWebViewController *searchWeb = [[SearchWebViewController alloc]init];
    
    NSString *str = [NSString stringWithFormat:@"%@search.do?searchkey=%@&i0=%@",MAINURL,keyWord,searchView.rescat];
    searchWeb.herfStr = str;
    if(searchView&&keyWord.length > 0)
    {
        [searchView.searchField resignFirstResponder];
        searchView.searchField.returnKeyType = UIReturnKeyDefault;
        searchWeb.searchStr = keyWord;
        NSUserDefaults *userDefault = [NSUserDefaults new];
        NSMutableArray *arr = [NSMutableArray array];
        NSArray  *hisArr = [userDefault objectForKey:@"searchHistory"];
        if(hisArr.count > 0)
        {
            arr = [NSMutableArray arrayWithArray:hisArr];
        }
        [arr insertObject:keyWord atIndex:0];
        [userDefault setObject:arr forKey:@"searchHistory"];

    }
    [self.navigationController pushViewController:searchWeb animated:YES];
}
#pragma -mark UIAlerViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSUserDefaults *userDefault = [NSUserDefaults new];
      //  NSArray *hisArr = [userDefault objectForKey:@"searchHistory"];
        [userDefault removeObjectForKey:@"searchHistory"];
    }
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
