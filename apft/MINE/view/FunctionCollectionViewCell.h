//
//  FunctionCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 15/11/12.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)NSDictionary *redDict;
@property (nonatomic,assign) BOOL isDraw;
@end
