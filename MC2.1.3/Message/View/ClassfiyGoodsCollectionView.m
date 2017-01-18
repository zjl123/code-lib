//
//  ClassfiyGoodsCollectionView.m
//  MiningCircle
//
//  Created by ql on 2016/12/9.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ClassfiyGoodsCollectionView.h"
#import "ClassfiyGoodsCollectionViewCell.h"
@implementation ClassfiyGoodsCollectionView
-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self reloadData];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 1.0f;
    flowLayout.minimumInteritemSpacing = 0.f;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.clipsToBounds = YES;
        self.headerHeight = 0.f;
        [self registerClass:[ClassfiyGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"classfiygoods"];
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassfiyGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classfiygoods" forIndexPath:indexPath];
    NSDictionary *dict = _dataArr[indexPath.row];
    cell.model = [[GoodsModel alloc]initWithDictionary:dict];
    cell.model.catId = _catId;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, 100);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width, self.headerHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassfiyGoodsCollectionViewCell *cell = (ClassfiyGoodsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.goodsDelegate jumpToGoodsDetails:cell.model];
}
@end
