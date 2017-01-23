//
//  CharacterCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/12/14.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterCollectionViewCell : UICollectionViewCell
//特点
@property (nonatomic, retain) NSDictionary *characters;
//商品数量
@property (nonatomic, assign) NSInteger num;
@end
