//
//  SVTopScrollView.h
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVTopScrollView : UIView
{
    NSInteger userSelectedChannelID;        //点击按钮选择名字ID
   // NSInteger scrollViewSelectedChannelID;  //滑动列表选择名字ID
    
    UIView *shadowImageView;   //选中阴影
}
@property (nonatomic, retain) NSArray *nameArray;
@property (nonatomic,retain)NSMutableArray *wArray;
@property(nonatomic,retain)NSMutableArray *buttonOriginXArray;
@property(nonatomic,retain)NSMutableArray *buttonWithArray;

//@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, copy) void(^IndexChangeBlock )(NSInteger index);
@property (strong, nonatomic) UICollectionView *titleCollectionView;
+ (SVTopScrollView *)shareInstance;
/**
 *  加载顶部标签
 */
- (void)initWithNameButtons;

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
@end
