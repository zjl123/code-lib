//
//  WebCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 16/9/7.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol jumpdelegate <NSObject>

-(void)jump:(NSString *)str;
-(void)jumpToLogin;
-(void)jumpToConversation:(NSString *)str;
@end
@interface WebCollectionViewCell : UICollectionViewCell <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *web;

@property (nonatomic,retain) NSString *strUrl;
@property (nonatomic,weak) id <jumpdelegate>jumpdelegate;
@end
