//
//  ListCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 16/4/18.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(retain,nonatomic)NSDictionary *info;
@end
