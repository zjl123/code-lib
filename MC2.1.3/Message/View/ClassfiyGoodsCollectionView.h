//
//  ClassfiyGoodsCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/9.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@protocol GoodsDetailDelegate <NSObject>

-(void)jumpToGoodsDetails:(GoodsModel *)model;

@end
@interface ClassfiyGoodsCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) NSArray *dataArr;
@property (nonatomic, assign) NSInteger classfiySection;
@property (nonatomic, assign) NSInteger classfiyRow;
@property (nonatomic, assign) NSInteger headerHeight;
@property (nonatomic, retain) NSString *catId;
@property (nonatomic, weak) id <GoodsDetailDelegate>goodsDelegate;
@end
