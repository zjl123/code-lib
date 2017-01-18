//
//  GoodsDetailCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,weak) UIViewController *vc;
@end
