//
//  NickNameViewController.h
//  MiningCircle
//
//  Created by ql on 16/7/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"

@class NickNameViewController;
@protocol NickNameDelegate <NSObject>

-(void)modifyName:(NickNameViewController *)nickViewController didFinished :(NSString *)nickName;

@end
@interface NickNameViewController : BackButtonViewController
@property(nonatomic,retain)NSString *nameStr;
@property(nonatomic,strong)id<NickNameDelegate> nickDelegate;
@end
