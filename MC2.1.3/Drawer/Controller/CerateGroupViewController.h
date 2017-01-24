//
//  CerateGroupViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/24.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadDetailViewController.h"

@protocol ProtrailDelegate <NSObject>

-(void)transProtrailUrl:(NSString *)protrailUrl;

@end
@interface CerateGroupViewController : HeadDetailViewController
@property(retain, nonatomic) NSArray *useridArr;
@property (assign, nonatomic) BOOL isCreate;
@property (weak, nonatomic) id <ProtrailDelegate>proDelegate;
@end
