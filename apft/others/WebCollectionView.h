//
//  WebCollectionView.h
//  MiningCircle
//
//  Created by ql on 16/9/7.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
     NSString *strUrl1;
}
@property (nonatomic,retain)NSArray *funArr;
@property (nonatomic,retain)UIViewController *controller;
+ (WebCollectionView *)shareInstance;
-(void)loadData;
@end
