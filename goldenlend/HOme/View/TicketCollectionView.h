//
//  TicketCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TicketCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(retain, nonatomic)NSString *flag;

@property(retain, nonatomic)NSArray *dataArr;

//character的数据源
@property(retain, nonatomic)NSDictionary *dataDict;

@end
