//
//  ImgCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2017/1/16.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *potrailView;
@property (retain, nonatomic) NSDictionary *info;
@end
