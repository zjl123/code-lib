//
//  HudView.h
//  MiningCircle
//
//  Created by ql on 16/10/13.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (assign, nonatomic) CGFloat time;
-(void)stopShow;
@end
