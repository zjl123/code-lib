//
//  FriendDetailViewController.h
//  MiningCircle
//
//  Created by ql on 16/10/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserModel.h"
#import "BackButtonViewController.h"
@protocol FreshDelegate <NSObject>

-(void)refresh:(BOOL)isRefresh andNewData:(id)newData;

@end
@interface FriendDetailViewController : BackButtonViewController
@property (nonatomic,strong) IMUserModel *model;
@property (nonatomic,weak)id<FreshDelegate>freshDelegate;
@end
