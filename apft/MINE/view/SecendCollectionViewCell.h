//
//  SecendCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)NSDictionary *dict;
@end
