//
//  ClassfiyGoodsCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/9.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassfiyGoodsCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSInteger classfiySection;
@property (nonatomic, assign) NSInteger classfiyRow;
@property (nonatomic, assign) NSInteger headerHeight;
@end
