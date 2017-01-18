//
//  BaseViewController.h
//  MiningCircle
//
//  Created by ql on 16/1/20.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
@interface BaseViewController : UIViewController
{
    UIWebView *web;
    NSString *strUrl1;
}
-(void)loadUrl;
//刷新
-(void)refreshWeb;
-(void)setUpKuangYeYi;
-(void)response:(NSNotification *)n;
-(void)callApp:(NSArray *)arr;
-(void)jumpWebViewWithoutTitle:(NSString *)webHerf;
-(void)jumpWebView:(NSString *)webHref;
-(void)gotoLogin;
-(void)getValue;
/*
 *搜索栏隐藏
 */
-(void)searchHidden;
/**
 建立searchbar
 */
-(void)setUpSearchBar;
/**
 *更新搜索框的数据
 */
-(void)refreshSearchData;
-(void)location;
@property (nonatomic,assign)BOOL isRefresh;
@end
