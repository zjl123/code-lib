//
//  ShareView.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/17.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
@interface ShareView : UIView<UIGestureRecognizerDelegate>

-(void)share:(NSArray *)params controller:(UIViewController *)controller
;
@end
