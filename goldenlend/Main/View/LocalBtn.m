//
//  LocalBtn.m
//  MiningCircle
//
//  Created by ql on 16/9/7.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "LocalBtn.h"

@implementation LocalBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
-(void)setSearchTitle:(NSString *)searchTitle
{
    _searchTitle = searchTitle;
    [searchTitle addObserver:self forKeyPath:@"searchTitle" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];

}
-(void)dealloc
{
    [self.searchTitle removeObserver:self forKeyPath:@"searchTitle"];
}
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [self setTitle:self.searchTitle forState:UIControlStateNormal];
    [self setTitle:self.searchTitle forState:UIControlStateSelected];
}
@end
