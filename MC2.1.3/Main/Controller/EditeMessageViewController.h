//
//  EditeMessageViewController.h
//  MiningCircle
//
//  Created by ql on 16/1/11.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
@interface EditeMessageViewController : BackButtonViewController
@property(nonatomic,retain)NSArray *phoneArr;
@property(nonatomic,retain)NSString *msg;
@property(nonatomic,retain)NSArray *nameArr;
@property(nonatomic,retain)NSString *urlStr;
@end
