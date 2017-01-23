//
//  MyCollectionVIew.h
//  MiningCircle
//
//  Created by ql on 16/5/14.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol jumpBanner <NSObject>

-(void)jumpToBanner:(NSString*)strUrl;

@end

@interface MyCollectionVIew : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)int flag;
@property (nonatomic,weak) id <jumpBanner>jumpDelegate;
@end
