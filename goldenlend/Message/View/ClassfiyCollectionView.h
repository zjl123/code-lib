//
//  ClassfiyCollectionView.h
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassfiyDelegate <NSObject>

-(void)ClassfiyClick:(NSInteger)section andRow:(NSInteger)row andTag:(NSString *)tagStr;
;

@end
@interface ClassfiyCollectionView : UICollectionView
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic,weak) id<ClassfiyDelegate> classfiyDelegate;
@end
