//
//  ScrollerCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ScrollerCollectionViewCell.h"
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
    _bannerView.contentSize = CGSizeMake(width1*3, bannerHeight);
    _bannerView.delegate = self;
    _bannerView.showsVerticalScrollIndicator = NO;
  //  _bannerView.scrollDirection = uisc
    ;
  //  _bannerView.pagingEnabled = YES;
  //  _bannerView.bounces = NO;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(width1*i, 0, width1, bannerHeight);
        imgView.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
        [_bannerView addSubview:imgView];
    }
    _pageView.currentPage = 0;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    self.title.text = info[@"title"];
    self.subTitle.text = info[@"subTitle"];
    NSString *pStr = [NSString stringWithFormat:@"￥%@",info[@"price"]];//  info[@"price"];
    if(pStr.length > 0)
    {
        self.price.text = pStr;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageView.currentPage = scrollView.contentOffset.x/width1;
}

@end
