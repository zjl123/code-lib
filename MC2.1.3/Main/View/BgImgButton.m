//
//  BgImgButton.m
//  GoldenLend
//
//  Created by ql on 16/3/8.
//  Copyright © 2016年 zjl. All rights reserved.
//  默认样式 单图

#import "BgImgButton.h"
#import "UIButton+WebCache.h"
@implementation BgImgButton
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
-(void)setBgImg:(NSString *)bgImg
{
    _bgImg = bgImg;
    [bgImg addObserver:self forKeyPath:@"bgImg" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
-(void)setSearchKey:(NSString *)searchKey
{
    _searchKey = searchKey;
    [searchKey addObserver:searchKey forKeyPath:@"searchKey" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
-(void)dealloc
{
    [self.bgImg removeObserver:self forKeyPath:@"bgImg"];
    [self.searchKey removeObserver:self forKeyPath:@"searchKey"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.bgImg.length > 0)
    {
        NSURL *url = [NSURL URLWithString:self.bgImg];
        [self sd_setImageWithURL:url forState:UIControlStateNormal];
        [self sd_setImageWithURL:url forState:UIControlStateSelected];
    }
    if(self.searchKey.length > 0)
    {
        [self setTitle:self.searchKey forState:UIControlStateNormal];
    }

}
-(void)setHighlighted:(BOOL)highlighted{}
@end
