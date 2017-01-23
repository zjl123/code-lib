//
//  BaseWebVIew.h
//  MiningCircle
//
//  Created by ql on 16/5/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JumpDelegate <NSObject>

-(void)jump:(NSString*)url;

@end
@interface BaseWebVIew : UIWebView<UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)NSString *strUrl;
@property (nonatomic,strong)id <JumpDelegate>jDelegate;
@end
