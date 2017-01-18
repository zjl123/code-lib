//
//  ShareCollectionview.h
//  MiningCircle
//
//  Created by ql on 16/9/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionview : UICollectionView <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSArray *stateArr;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *content;
@property (nonatomic,retain)NSURL *url;
@property (nonatomic,retain)UIImage *img;
@property (nonatomic,retain)UIViewController *controlller;
@end
