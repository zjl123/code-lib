//
//  ScrollerCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollerCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (retain, nonatomic)NSDictionary *info;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
@property (weak, nonatomic) IBOutlet UIScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) NSDictionary *bannerDict;
@end
