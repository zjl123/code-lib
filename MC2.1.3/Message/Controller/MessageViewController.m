//
//  MessageViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/7/27.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "MessageViewController.h"
#import "ClassfiyCollectionView.h"
#import "ClassfiyGoodsCollectionView.h"
#import "LocalBtn.h"
#import "BgImgButton.h"
#import "Tool.h"
#import "DataManager.h"
#import "GoodsViewController.h"
@interface MessageViewController ()<ClassfiyDelegate,GoodsDetailDelegate>

@end

@implementation MessageViewController
{
    ClassfiyGoodsCollectionView *classfiyGoods;
    ClassfiyCollectionView *classView;
    UIView *bgView ;
    UISwipeGestureRecognizer *swipRight;
    NSString *classfiyStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
  classfiyStr = @"默认";
#if KMIN
    [self setUpSearchBar];
#endif
  //  web.hidden = YES;
  //  [self setUpClassify];
  //  [self getLeftData];
  }
-(void)setUpKuangYeYi
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSArray *arr = [userDefault objectForKey:@"TBMenu"];
    NSDictionary *dict = arr[1];
    strUrl1 = [NSString stringWithFormat:@"%@&uap=ios",dict[@"act"]] ;
   // strUrl1 = @"http://192.168.1.220/apectown/index.html";
}
-(void)setUpClassify
{
    //分类
    classView = [[ClassfiyCollectionView alloc]initWithFrame:CGRectMake(0, 0, width1/4, height1-self.navigationController.navigationBar.frame.size.height-StatuesHeight-self.tabBarController.tabBar.frame.size.height-TABANOHEIGHT+12)];
    classView.classfiyDelegate = self;
    [self.view addSubview:classView];
    
    //分类详情
    classfiyGoods = [[ClassfiyGoodsCollectionView alloc]initWithFrame:CGRectMake(width1/4, 0, width1*3/4, height1-self.navigationController.navigationBar.frame.size.height-StatuesHeight-self.tabBarController.tabBar.frame.size.height-TABANOHEIGHT+12)];
    classfiyGoods.goodsDelegate = self;
    //swip只能设置一个方向，默认向右
    swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipRightClick:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [classfiyGoods addGestureRecognizer:swipRight];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipLeftClick:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [classfiyGoods addGestureRecognizer:swipLeft];
    [self.view addSubview:classfiyGoods];
    
}
-(void)swipRightClick:(UISwipeGestureRecognizer *)gesture
{
   // NSLog(@"右滑动");
    CGRect rect = classfiyGoods.frame;
    if(rect.origin.x < width1/4)
    {
        rect.origin.x = width1/4;
        rect.size.width = width1*3/4;
        classfiyGoods.frame = rect;
         classfiyGoods.headerHeight = 0.f;
        bgView.hidden = YES;
        [classfiyGoods reloadData];
    }
    
}
-(void)swipLeftClick:(UISwipeGestureRecognizer *)gesture
{
   // NSLog(@"左滑动");
    
    CGRect rect = classfiyGoods.frame;
    if(rect.origin.x > 0)
    {
        rect.origin.x = 0;
        rect.size.width = width1;
        classfiyGoods.frame = rect;
        classfiyGoods.headerHeight = 40.f;
        [self setUpFilterBar];
        [classfiyGoods reloadData];
    }
}
#pragma -mark ClassfiyDelegate
-(void)ClassfiyClick:(NSInteger)section andRow:(NSInteger)row andTag:(NSString *)tagStr andCatId:(NSString *)catId
{
    [self getRightData:catId];
    if(tagStr.length > 0)
    {
        classfiyStr = tagStr;
    }
    CGPoint p = classfiyGoods.contentOffset;
    p.y = 0;
    classfiyGoods.contentOffset = p;
    classfiyGoods.classfiySection = section;
    classfiyGoods.classfiyRow = row;
    [classfiyGoods reloadData];
}
-(void)setUpFilterBar
{
    if(!bgView)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        //line
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-1, width1, 1)];
        line.backgroundColor = RGB(248, 248, 248);
        [bgView addSubview:line];
        NSArray *arr = @[classfiyStr,@"销量",@"价格"];
        for (int i = 0; i < 3; i++) {
           // LocalBtn *btn = [[LocalBtn alloc]initWithFrame:CGRectMake(width1*i/3, 0, width1/3, bgView.frame.size.height)];
            BgImgButton *btn = [BgImgButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(width1*i/3, 0, width1/3, bgView.frame.size.height);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:RGB(150, 150, 150) forState:UIControlStateNormal];
            [btn setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.searchKey = arr[i];
            btn.tag = 600+i;
            [bgView addSubview:btn];
        }
    }
    else
    {
        bgView.hidden = NO;
        BgImgButton *btn = (BgImgButton *)[bgView viewWithTag:600];
       // [btn setTitle:classfiyStr forState:UIControlStateNormal];
        btn.searchKey = classfiyStr;
        
    }
}
-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == 600)
    {
        
        [self swipRightClick:swipRight];
    }
    else if (sender.tag == 601)
    {
    
    }
    else if (sender.tag == 602)
    {
        
    }
}
#pragma -mark Data(数据)
-(void)getLeftData
{
    NSString *lg = [Tool getPreferredLanguage];
    if([lg isEqualToString:@"zh-Hans"])
    {
        lg = @"cn";
    }
    NSDictionary *dict = @{@"cmd":@"getmenu",@"time":@"0",@"applabel":@"mc_goods",@"lg":lg,@"os":@"ios"};
    [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
      //  NSLog(@"resultBlock%@",resultBlock);
        NSArray *arr = resultBlock[@"slideMenu"];
        if(arr.count > 0)
        {
            classView.info = arr;
        }
    }];
}
-(void)getRightData:(NSString *)catId
{
    if (!catId||catId.length == 0) {
        catId = @"0";
    }
    NSDictionary *dict = @{@"cmd":@"getGoodsList",@"catId":catId,@"os":@"ios"};
    [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
     //   NSLog(@"resultBlock%@",resultBlock);
        NSArray *goodsList = resultBlock[@"goodsList"];
        if(goodsList.count > 0)
        {
            classfiyGoods.dataArr = goodsList;
            classfiyGoods.catId = catId;
        }
    }];

}
#pragma -mark GoodsDetailDelegate
-(void)jumpToGoodsDetails:(GoodsModel *)model
{
    
    GoodsViewController *goodsDetail = [[GoodsViewController alloc]init];
        [self searchHidden];
   // goodsDetail.goodsId = goodId;
   // goodsDetail.catId = catId;
     goodsDetail.model = model;
    [self.navigationController pushViewController:goodsDetail animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
