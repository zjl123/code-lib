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
    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassfiyGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classfiygoods" forIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"第%ld大类的第%ld个分类中的第%ld个商品",(long)_classfiySection,(long)_classfiyRow,(long)indexPath.row];
    NSDictionary *dict =@{@"title":title,@"price":@"99.99"};
    cell.model = [[GoodsModel alloc]initWithDictionary:dict];
    
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
@end
