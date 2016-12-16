//
//  RemarkNameViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/20.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransformValueDelegate <NSObject>

-(void)transformValues:(NSString *)value;

@end
@interface RemarkNameViewController : UIViewController
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, weak) id <TransformValueDelegate>transDelegate;
@property (retain, nonatomic) NSString *remarkTip;
@property (retain, nonatomic) NSString *remarkFieldTip;
@property (retain, nonatomic) NSString *judgeStr;
@end
