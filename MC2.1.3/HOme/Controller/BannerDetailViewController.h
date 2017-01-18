//
//  BannerDetailViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/9/10.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@interface BannerDetailViewController : WebViewController
@property(nonatomic,retain)NSString *herfStr;
@property(nonatomic,retain)NSString *testStr;
@property(nonatomic,retain)NSString *searchStr;
//推送到这个页面的时候隐藏searchView(jpush)
@property(nonatomic,assign)BOOL pushHidden;
@end
