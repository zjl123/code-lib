//
//  PersonCenterViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/19.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PersonCenterViewController : BaseViewController
@property (nonatomic,assign) BOOL isRed;
@property (nonatomic,assign) BOOL isLog;
//@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,retain) NSArray *tbArr;
@end
