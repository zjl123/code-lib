//
//  GoodsDetailCollectionView.m
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GoodsDetailCollectionView.h"
#import "ScrollerCollectionViewCell.h"
#import "NSString+Exten.h"
#import "TicketCollectionViewCell.h"
#import "PromotionCollectionViewCell.h"
#import "TicketCollectionView.h"
@interface GoodsDetailCollectionView ()<UIGestureRecognizerDelegate>
@property(nonatomic, assign)CGFloat bannerHeight;
@end

@implementation GoodsDetailCollectionView
{
    NSDictionary *firstDict;
    NSArray *ticketArr;
    NSArray *promotionArr;
    UIView *bgView ;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 1.0f;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.backgroundColor = RGB(240, 240, 240);
       // self.showsVerticalScrollIndicator = NO;
      //  self.showsHorizontalScrollIndicator = NO;
       // self.alwaysBounceVertical = YES;
      //  self.scrollEnabled = YES;
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ScrollerCollectionViewCell class] forCellWithReuseIdentifier:@"banner"];
        [self registerClass:[TicketCollectionViewCell class] forCellWithReuseIdentifier:@"ticket"];
        [self registerClass:[PromotionCollectionViewCell class] forCellWithReuseIdentifier:@"promotion"];
        _bannerHeight = 300;
        firstDict = @{@"title":@"黄金",@"subTitle":@"纯度高达99.99%",@"price":@"330"};
        promotionArr = @[@{@"tag":@"限购",@"tagDetail":@"满19.90另加19.90元，或满29.90另加29.90元，或满39.90另加39.90元，即可在购物车换购热销商品"},@{@"tag":@"赠品",@"tagDetail":@"赠iPhone7plus一部"},@{@"tag":@"满额返券",@"tagDetail":@"订单满99收货后返320春运大礼包-火车票机票酒店"}];
        ticketArr = @[@{@"title":@"仅贵金属可用",@"total":@"300",@"offSet":@"50",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"600",@"offSet":@"100",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"1200",@"offSet":@"200",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"3000",@"offSet":@"500",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"5000",@"offSet":@"1000",@"time":@"2016-12-30"}];
        [self getFirstHeight];

    }
    return self;
}

-(void)getFirstHeight
{
    _bannerHeight = 350;
    NSString *title = firstDict[@"title"];
    CGSize titleSize = [title getStringSize:[UIFont systemFontOfSize:14] width:width1-16];
    NSString *subTitle = firstDict[@"subTitle"];
    CGSize subSize = [subTitle getStringSize:[UIFont systemFontOfSize:13] width:width1-16];
    _bannerHeight += (subSize.height+titleSize.height);
    [self reloadData];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        //领券
        [self popView:@"领优惠券" andData:ticketArr];
        
    }
    else if (indexPath.row == 2)
    {
        //优惠
         [self popView:@"促销" andData:promotionArr];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        //banner
        if(indexPath.row == 0)
        {
            ScrollerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"banner" forIndexPath:indexPath];
            cell.info = firstDict;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            TicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ticket" forIndexPath:indexPath];
            cell.info = ticketArr;
            return cell;

        }
        else
        {
            PromotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"promotion" forIndexPath:indexPath];
            cell.info = promotionArr;
            return cell;
        }
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            NSLog(@"%f",_bannerHeight);
            return CGSizeMake(self.frame.size.width, _bannerHeight);
        }
        else
        {
            NSString *str = @"我";
            CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:100];
            CGFloat h = size.height*promotionArr.count+7*(promotionArr.count-1)+8*2;
            return CGSizeMake(self.frame.size.width, h);
        }
    }
    return CGSizeMake(0, 0);
}

-(void)popView:(NSString *)tag andData:(NSArray *)data
{
    CGFloat h = self.frame.size.height;
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, h)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.vc.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [bgView addGestureRecognizer:tap];
    
    
    //title背景
    CGFloat titleViewHeignt = 40;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, h/4-40, width1, titleViewHeignt)];
    titleView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleView];
    //title标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((width1-100)/2, 0, 100, 40)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(157, 157, 157);
    titleLabel.text = tag;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(width1-23, (titleViewHeignt-20)/2, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    //优惠券
    TicketCollectionView *ticketView = [[TicketCollectionView alloc]initWithFrame:CGRectMake(0, h/4, width1, h*3/4)];
    ticketView.flag = tag;;
    ticketView.dataArr = data;
    [bgView addSubview:ticketView];
    
}
-(void)closeClick:(UIButton *)sender
{
    bgView.hidden = YES;
}
-(void)tapClick:(UITapGestureRecognizer *)gesture
{
    gesture.view.hidden = YES;
}
#pragma -mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view.superview isKindOfClass:[UICollectionViewCell class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}
@end
