//
//  UIWebView+Addition.m
//  MiningCircle
//
//  Created by ql on 15/12/16.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "UIWebView+Addition.h"

@implementation UIWebView (Addition)
-(NSString *)pageTitle
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(NSString *)metaContent:(NSString *)key
{
    NSString *str = [NSString stringWithFormat:@"document.querySelector('meta[name=\"%@\"]').getAttribute('content')",key];
    return [self stringByEvaluatingJavaScriptFromString:str];
}
@end
