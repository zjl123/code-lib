//
//  ScrollerCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ScrollerCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#define bannerHeight 300
@implementation ScrollerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ScrollerCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setBannerDict:(NSDictionary *)bannerDict
{
    NSArray *arr = _bannerView.subviews;
    for (UIView *view in arr) {
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    
    NSArray *keys = bannerDict.allKeys;
    _bannerView.contentSize = CGSizeMake(width1*keys.count, bannerHeight);
  //  _bannerView.backgroundColor = [UIColor redColor];
    _bannerView.delegate = self;
    _bannerView.showsVerticalScrollIndicator = NO;

    for (int i = 0; i <keys.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(width1*i, 0, width1, bannerHeight);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:bannerDict[keys[i]]]];
        [_bannerView addSubview:imgView];
    }
    _pageView.numberOfPages = keys.count;
    _pageView.currentPage = 0;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageView.currentPage = scrollView.contentOffset.x/width1;
}

@end
