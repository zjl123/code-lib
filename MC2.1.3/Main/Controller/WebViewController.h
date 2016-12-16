//
//  WebViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/9/25.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "SearchView.h"
@interface WebViewController : UIViewController
{
    UIWebView *web;
    NSString *strurl;
}
@property(nonatomic, retain)UILabel *label;
@property(nonatomic, retain)GreyView *greyView;
@property(nonatomic, retain)ActivityView *activity;
@property (nonatomic ,assign)BOOL isTitle;
-(void)activituStartShow;
-(void)activityStopShow;

@end
