//
//  GoodsViewController.m
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsDetailCollectionView.h"
#import "FunctionCollectionViewCell.h"
#import "PromotionCollectionViewCell.h"
#import "TicketCollectionViewCell.h"
#import "ScrollerCollectionViewCell.h"
#import "NSString+Exten.h"
#import "TicketCollectionView.h"
#import "CharacterCollectionViewCell.h"
#import "ShopCollectionViewCell.h"
#import "TipCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"
#import "UpDownBtn1.h"
#import "DataManager.h"
#import "GoodsModel.h"
#define END_DRAG_SHOW_HEIGHT 60.0f
@interface GoodsViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property(nonatomic, retain)UIView *allContentView;
@property(nonatomic, retain)UIView *downView;
@property(nonatomic, retain)UILabel *downLabelOnNav;
@end

@implementation GoodsViewController
{
    UIScrollView *bannerView;
    UIPageControl *pageView;
    NSArray *promotionArr;
    NSArray *ticketArr;
    NSDictionary *characterDict;
    CGFloat bannerHeight;
    NSDictionary *firstDict;
    UICollectionView *collView;
    UIView *bgView;
    UILabel *downLabel;
    WKWebView *downWebView;
    CGFloat minY;
    CGFloat maxY;
    //nav上放置btn的view
    UIView *navBgView;
    //nav上定位button的view
    UIView *flagView;
  //  GoodsModel *model;
    
}
-(UILabel *)downLabelOnNav
{
    if(!_downLabelOnNav)
    {
        NSString *str = @"图文详情";
        CGSize size = [str getStringSize:[UIFont systemFontOfSize:17] width:width1];
        CGFloat w = size.width + 10;
        _downLabelOnNav = [[UILabel alloc]initWithFrame:CGRectMake((width1-w)/2, NAVHEIGHT+StatuesHeight, w, NAVHEIGHT)];
        _downLabelOnNav.textAlignment = NSTextAlignmentCenter;
        _downLabelOnNav.textColor = [UIColor whiteColor];
        _downLabelOnNav.text = str;
        [self.navigationController.navigationBar insertSubview:_downLabelOnNav atIndex:-1];
    }
    return _downLabelOnNav;
}
-(UIView *)allContentView
{
    if(!_allContentView)
    {
        _allContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, (height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT)*2)];
        [self.view addSubview:_allContentView];
    }
    return _allContentView;
}
-(void)loadWeb
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [downWebView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   // [self setUpCollectionView];
    //导航栏上的两个按钮
    //获取数据
    [self getData];
    [self setUpBtnOnNav];
    //主体控件
    [self setUpScrollerView];
    //图文详情
    [self setUpDownView];
    self.downLabelOnNav.hidden = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_downLabelOnNav removeFromSuperview];
    [navBgView removeFromSuperview];
}
-(void)setUpBtnOnNav
{
    
   
    CGFloat viewX = CGRectGetMaxX(backBtn.frame)+10;
    navBgView = [[UIView alloc]initWithFrame:CGRectMake(viewX,0, width1-viewX*2, NAVHEIGHT)];
    [self.navigationController.navigationBar addSubview:navBgView];
    NSArray *arr = @[@"商品",@"详情"];
    CGSize size = [arr[0] getStringSize:[UIFont systemFontOfSize:15] width:100];
  //  CGFloat w = 50;
     CGFloat x = navBgView.frame.size.width/2-size.width-10;
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, 7, size.width, 30);
        btn.tag = 2000+i;
        [btn addTarget:self action:@selector(buttonOnNav:) forControlEvents:UIControlEventTouchUpInside];
        x = navBgView.frame.size.width/2+10;
        [navBgView addSubview:btn];
    }
    UIButton *btn = [navBgView viewWithTag:2000];
    CGFloat flagX = CGRectGetMinX(btn.frame);
    flagView = [[UIView alloc]initWithFrame:CGRectMake(flagX, NAVHEIGHT-3, btn.frame.size.width, 3)];
    flagView.backgroundColor = [UIColor whiteColor];
    [navBgView addSubview:flagView];
    
}
-(void)buttonOnNav:(UIButton *)sender
{
    CGFloat x = CGRectGetMinX(sender.frame);
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = flagView.frame;
        rect.origin.x = x;
        rect.size.width = sender.frame.size.width;
        flagView.frame = rect;
    }];

    if(sender.tag == 2000)
    {
         [bannerView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(sender.tag == 2001)
    {
        [bannerView setContentOffset:CGPointMake(width1, 0) animated:YES];
    }
}
-(void)setUpScrollerView
{
    bannerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT)];
    CGFloat bannerHight = bannerView.frame.size.height;
    bannerView.contentSize = CGSizeMake(width1*2,bannerHight);
    bannerView.delegate = self
    ;
    bannerView.showsVerticalScrollIndicator = NO;
    bannerView.showsHorizontalScrollIndicator = NO;
    bannerView.pagingEnabled = YES;
    bannerView.bounces = NO;
    pageView.currentPage = 0;
    [self.allContentView addSubview:bannerView];
    //第0页
    [self setUpCollectionView];
    //第一页
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width1, 0, width1, bannerHight)];
    imgView1.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
    [bannerView addSubview:imgView1];
    //    //第二页
    //    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(2*width1, 0, width1, bannerHight)];
    //    imgView2.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
    //    [bannerView addSubview:imgView2];
}

-(void)setUpDownView
{
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT, width1, height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT)];
    _downView.backgroundColor = RGB(245, 245, 245);
    [self.allContentView addSubview:_downView];
    //  CGFloat webY = CGRectGetMaxY(downLabel.frame);
    downWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT)];
    downWebView.scrollView.delegate = self;
    // downWebView.backgroundColor = [UIColor yellowColor];
    [_downView addSubview:downWebView];
    
    [self loadWeb];
    
    downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, width1, 30)];
    downLabel.font = [UIFont systemFontOfSize:13];
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.text = @"下拉返回商品详情";
    downLabel.alpha = 0.0f;
    downLabel.backgroundColor = [UIColor clearColor];
    [_downView insertSubview:downLabel aboveSubview:downWebView];
    
}

-(void)setUpCartBar
{
    UIView *cartBg = [[UIView alloc]initWithFrame:CGRectMake(0,height1-TABBARHEIGHT-NAVHEIGHT-StatuesHeight, width1,TABBARHEIGHT)];
    cartBg.backgroundColor = RGB(240, 240, 240);
    [self.view insertSubview:cartBg aboveSubview:bannerView];
    
    NSArray *arr = @[@"客服",@"店铺",@"加入购物车",@"立即购买"];
    NSArray *imgArr= @[@"shop",@"wang"];
    int x = 0;
    for (int i = 0; i < arr.count; i++) {
        
        //btn.backgroundColor = [UIColor yellowColor];
     //   UIButton *btn;
        if(i < 2)
        {
           UpDownBtn1 *btn = [UpDownBtn1 buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, 0, TABBARHEIGHT, TABBARHEIGHT);
            btn.title = arr[i];
          //  [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.img = imgArr[i];
            [btn setTitleColor:RGB(151, 151, 151) forState:UIControlStateNormal];
            x = CGRectGetMaxX(btn.frame);
            [cartBg addSubview:btn];

        }
        else
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            if(i == 2)
            {
                btn.backgroundColor = RGB(252, 176, 64) ;
            }
            else if (i == 3)
            {
                btn.backgroundColor = RGB(242, 41, 41) ;
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.frame = CGRectMake(x, 0, (width1-2*TABBARHEIGHT)/2, TABBARHEIGHT);
            x = CGRectGetMaxX(btn.frame);
            [cartBg addSubview:btn];

        }
    }
    
}
-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 1.0f;
    collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, width1, bannerView.frame.size.height) collectionViewLayout:flowLayout];
    collView.showsVerticalScrollIndicator = NO;
    collView.backgroundColor = RGB(240, 240, 240);
    collView.delegate = self;
    collView.dataSource = self;
    [collView registerClass:[ScrollerCollectionViewCell class] forCellWithReuseIdentifier:@"banner"];
    [collView registerClass:[TicketCollectionViewCell class] forCellWithReuseIdentifier:@"ticket"];
    [collView registerClass:[PromotionCollectionViewCell class] forCellWithReuseIdentifier:@"promotion"];
    [collView registerClass:[CharacterCollectionViewCell class] forCellWithReuseIdentifier:@"character"];
    [collView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:@"shop"];
    [collView registerClass:[TipCollectionViewCell class] forCellWithReuseIdentifier:@"pull"];
    bannerHeight = 300;
    firstDict = @{@"title":@"黄金",@"subTitle":@"纯度高达99.99%",@"price":@"330"};
    promotionArr = @[@{@"tag":@"限购",@"tagDetail":@"满19.90另加19.90元，或满29.90另加29.90元，或满39.90另加39.90元，即可在购物车换购热销商品"},@{@"tag":@"赠品",@"tagDetail":@"赠iPhone7plus一部"},@{@"tag":@"满额返券",@"tagDetail":@"订单满99收货后返320春运大礼包-火车票机票酒店"}];
    ticketArr = @[@{@"title":@"仅贵金属可用",@"total":@"300",@"offSet":@"50",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"600",@"offSet":@"100",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"1200",@"offSet":@"200",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"3000",@"offSet":@"500",@"time":@"2016-12-30"},@{@"title":@"仅贵金属可用",@"total":@"5000",@"offSet":@"1000",@"time":@"2016-12-30"}];
    characterDict = @{@"颜色":@[@"褐色",@"红色",@"粉色"],@"尺寸":@[@"36",@"37",@"38"]};
    [self getFirstHeight];
    
    
    [bannerView addSubview:collView];
    
    [self setUpCartBar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
    if(indexPath.row == 0)
    {
        ScrollerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"banner" forIndexPath:indexPath];
        cell.info = firstDict;
        cell.bannerDict = _model.bannerDict;
        cell.title.text = _model.title;
        cell.subTitle.text = _model.subTitle;
        
        NSString *str = [NSString stringWithFormat:@"￥%@",_model.price];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
        [mutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 1)];
        
        cell.price.attributedText = mutStr;
        return cell;
    }
    else if(indexPath.row == 1)
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
    else if(indexPath.section == 1)
    {
        CharacterCollectionViewCell *cell = [collView dequeueReusableCellWithReuseIdentifier:@"character" forIndexPath:indexPath];
        cell.characters = characterDict;
        return cell;

    }
    else if(indexPath.section == 2)
    {
        ShopCollectionViewCell *cell = [collView dequeueReusableCellWithReuseIdentifier:@"shop" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        TipCollectionViewCell *cell = [collView dequeueReusableCellWithReuseIdentifier:@"pull" forIndexPath:indexPath];
        return cell;
    }
        
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.view.frame.size.width;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            NSLog(@"%f",bannerHeight);
            return CGSizeMake(w, bannerHeight);
        }
        
        else if(indexPath.row == 1)
        {
            NSString *str = @"我";
            CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:100];
            
            CGFloat h = size.height+10*2+5;
            return CGSizeMake(w, h);
        }
        else if (indexPath.row == 2)
        {
            NSString *str = @"我";
            CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:100];
            CGFloat h = size.height*promotionArr.count+7*(promotionArr.count-1)+10*2;
            return CGSizeMake(w, h);
        }
    }
    else if(indexPath.section == 1)
    {
        return CGSizeMake(w, 44);
    }
    else if (indexPath.section == 2)
    {
        return CGSizeMake(width1, 100);
    }
    else if (indexPath.section == 3)
    {
        return CGSizeMake(width1, 30);
    }
    return CGSizeMake(0, 0);

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return CGSizeMake(width1, 0);
    }
    else
    {
         return CGSizeMake(width1, 15);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
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
    else
    {
        [self popView:@"特征" andData:characterDict];
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if(scrollView == downWebView.scrollView)
    {
        if(offset <= -10)
        {
          //  NSLog(@"dddd%f---%f",offset,fabs(offset/10.0));
            downLabel.alpha = fabs(offset)/20.0;
        }
        else
        {
            // NSLog(@"ggggg%f----%f",offset,fabs(offset/10.0));
            downLabel.alpha = fabs(offset)/20.0;
        }
        
        if(offset <= -END_DRAG_SHOW_HEIGHT)
        {
            downLabel.text = @"释放返回商品详情";
        }
        else
        {
            downLabel.text = @"下拉返回商品详情";
        }
    }
}

/**
 *  每次拖拽都会回调
*   @param decelerate YES 为滑动减速动画，NO时没有滑动减速动画
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        if(offsetX > 0)
        {
        }
        {

        CGFloat offset = scrollView.contentOffset.y;
        if(scrollView == collView)
        {
            if(offset < 0)
            {
                minY = MIN(minY, offset);
            }
            else
            {
                maxY = MAX(maxY, offset);
            }
        }
        else
        {
            minY = MIN(minY, offset);
        }
     //   NSLog(@"%f---%f",offset,collView.contentSize.height);
        //滚到图文详情
        if(offset >= collView.contentSize.height-collView.frame.size.height+END_DRAG_SHOW_HEIGHT)
        {
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformTranslate(self.allContentView.transform, 0, -(height1-NAVHEIGHT-StatuesHeight-TABBARHEIGHT));
                downLabel.alpha = 0.0f;
                //按钮滚出去
                CGRect bgRect = navBgView.frame;
                bgRect.origin.y = -NAVHEIGHT-StatuesHeight;
                navBgView.frame = bgRect;
                //图文详情label滚上来
                CGRect rect = self.downLabelOnNav.frame;
                rect.origin.y = 0;
                self.downLabelOnNav.frame = rect;
                [self.navigationController.navigationBar insertSubview:self.downLabelOnNav atIndex:0];
            } completion:^(BOOL finished) {
                maxY = 0.0f;
            }];
        }
        
        //滚到商品详情
        
        if(minY < -END_DRAG_SHOW_HEIGHT)
        {
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformIdentity;
                //按钮滚回来
                CGRect bgRect = navBgView.frame;
                bgRect.origin.y = 0;
                navBgView.frame = bgRect;
                //图文详情label滚下去
                CGRect rect = self.downLabelOnNav.frame;
                rect.origin.y = NAVHEIGHT;
                self.downLabelOnNav.frame = rect;
                [self.view insertSubview:self.downLabelOnNav atIndex:0];
            } completion:^(BOOL finished) {
                minY = 0.0f;
                downLabel.text = @"下拉返回商品详情";
            }];
        }
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    pageView.currentPage = bannerView.contentOffset.x/width1;

    if(offsetX == width1)
    {
        UIButton *btn = [navBgView viewWithTag:2001];
        [self buttonOnNav:btn];
    }
    else if(offsetX == 0)
    {
        UIButton *btn = [navBgView viewWithTag:2000];
        [self buttonOnNav:btn];

    }
}
-(void)popView:(NSString *)tag andData:(id)data
{
    CGFloat h = self.view.frame.size.height;
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, h)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
   // bgView.tag = 1100;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [bgView addGestureRecognizer:tap];
    
    
    //title背景
    CGFloat titleViewHeignt = 50;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, h/4-titleViewHeignt, width1, titleViewHeignt)];
    titleView.tag = 1100;
    titleView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleView];
    if(![tag isEqualToString:@"特征"])
    {
        //title标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((width1-100)/2, 0, 100, titleViewHeignt)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = RGB(157, 157, 157);
        titleLabel.text = tag;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:titleLabel];
    }
    else
    {
        //特征
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, -15, 55, 55)];
        imgView.backgroundColor = [UIColor greenColor];
        imgView.layer.cornerRadius = 5.0f;
        //[imgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"gray-mc"]];
        [titleView addSubview:imgView];
        
        CGFloat priceX = CGRectGetMaxX(imgView.frame)+10;
        CGFloat priceH = [Tool getLabelHight:[UIFont systemFontOfSize:16]];
        CGFloat priceW = width1-priceX-23;
        CGFloat priceY = 5;
        //价格
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
      //  priceLabel.backgroundColor = [UIColor lightGrayColor];
        priceLabel.textColor = [[UIColor redColor]colorWithAlphaComponent:0.8];
        priceLabel.text = @"￥99.99";
        priceLabel.font = [UIFont systemFontOfSize:16];
        [titleView addSubview:priceLabel];
        
        CGFloat totalY = CGRectGetMaxY(priceLabel.frame)+5;
        //库存
        CGFloat totalH = [Tool getLabelHight:[UIFont systemFontOfSize:12]];
        UILabel *totallabel = [[UILabel alloc]initWithFrame:CGRectMake(priceX, totalY, 100, totalH)];
        totallabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        totallabel.font = [UIFont systemFontOfSize:12];
        totallabel.text = @"库存9999件";
        [titleView addSubview:totallabel];
        
        
    }
    
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(width1-23, (titleViewHeignt-20)/2, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    //优惠券
    TicketCollectionView *ticketView = [[TicketCollectionView alloc]initWithFrame:CGRectMake(0, h/4, width1, h*3/4)];
    ticketView.flag = tag;
   
    if([data isKindOfClass:[NSArray class]])
    {
         ticketView.dataArr = data;
        // ticketView.dataDict = @{};
    }
    else
    {
        ticketView.dataDict = data;
       // ticketView.dataArr = @[];
    }
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

-(void)getFirstHeight
{
    bannerHeight = 350;
    NSString *title = firstDict[@"title"];
    CGSize titleSize = [title getStringSize:[UIFont systemFontOfSize:14] width:width1-16];
    NSString *subTitle = firstDict[@"subTitle"];
    CGSize subSize = [subTitle getStringSize:[UIFont systemFontOfSize:13] width:width1-16];
    bannerHeight += (subSize.height+titleSize.height);
    [collView reloadData];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  //  UIView *view = touch.view;
 //   NSLog(@"%@",touch.view.class);
//    NSLog(@"%@",touch.view.superview.class);
    if([touch.view.superview isKindOfClass:[UICollectionViewCell class]]||[touch.view isKindOfClass:[UICollectionView class]] || touch.view.tag == 1100||touch.view.superview.tag == 1100 ||[touch.view isKindOfClass:[UICollectionReusableView class]])
    {
        return NO;
    }
    return YES;
}
-(void)getData
{
    if(_model.catId.length > 0 && _model.goodId.length > 0&&_model.catId&&_model.catId)
    {
        NSDictionary *dict = @{@"cmd":@"getGoodsInfo",@"id":_model.goodId,@"catId":_model.catId,@"os":@"ios"};
        [[DataManager shareInstance] ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
            NSLog(@"resultBlock%@",resultBlock);
            NSArray *arr = resultBlock[@"goodsInfo"];
            NSDictionary *dict = arr[0];
            if(dict&&dict.count>0)
            {
                _model = [[GoodsModel alloc]initWithDictionary:dict[@"goldbar"]];
                [collView reloadData];
            }
        }];
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
