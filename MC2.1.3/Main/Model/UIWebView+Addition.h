//
//  UIWebView+Addition.h
//  MiningCircle
//
//  Created by ql on 15/12/16.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <WebKit/WebKit.h>
@interface UIWebView (Addition)
-(NSString *)pageTitle;
-(NSString *)metaContent:(NSString *)key;
@end
