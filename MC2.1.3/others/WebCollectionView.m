//
//  WebCollectionView.m
//  MiningCircle
//
//  Created by ql on 16/9/7.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "WebCollectionView.h"
#import "WebCollectionViewCell.h"
#import "SVGloble.h"
#import "SVTopScrollView.h"
#import "Tool.h"
#import "MJRefresh.h"
#define POSITIONID (int)(scrollView.contentOffset.x/width1)
@implementation WebCollectionView

+ (WebCollectionView *)shareInstance {
    static WebCollectionView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 39, width1, [SVGloble shareInstance].globleHeight-39)];
    });
    return _instance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0.001;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
       // [self registerClass:[WebCollectionViewCell class] forCellWithReuseIdentifier:@"webCell"];
        UINib *nib = [UINib nibWithNibName:@"WebCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"webCell"];
    }
    return self;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _funArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"webCell" forIndexPath:indexPath];
    NSDictionary *dict = _funArr[indexPath.row];
    cell.jumpdelegate = _controller;
    cell.strUrl = dict[@"act"];
   // cell.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    //  [self loadData];
    
    // [SVTopScrollView shareInstance]sets
}
//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[SVTopScrollView shareInstance]setSelectedSegmentIndex:POSITIONID animated:YES];
}
-(void)loadData
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/_funArr.count)/pagewidth)+1;
    if(_funArr.count > 0)
    {
        NSDictionary *dict = _funArr[page];
        NSString *str = dict[@"act"];
        if(str.length > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
            WebCollectionViewCell *cell = (WebCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
            cell.strUrl = str;
            [cell.web.scrollView.mj_header beginRefreshing];
        }
    }
}
@end
