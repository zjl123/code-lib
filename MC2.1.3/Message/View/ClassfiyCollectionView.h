//
//  ClassfiyCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassfiyDelegate <NSObject>

-(void)ClassfiyClick:(NSInteger)section andRow:(NSInteger)row andTag:(NSString *)tagStr andCatId:(NSString *)catId;
;

@end
@interface ClassfiyCollectionView : UICollectionView
@property (nonatomic, retain) NSArray *info;
@property (nonatomic,weak) id<ClassfiyDelegate> classfiyDelegate;
@end
