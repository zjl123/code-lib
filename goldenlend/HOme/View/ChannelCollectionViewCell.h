//
//  ChannelCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 16/5/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (assign, nonatomic) BOOL isAdd;
@end
