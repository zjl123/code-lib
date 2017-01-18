//
//  ClassfiyCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassfiyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end
