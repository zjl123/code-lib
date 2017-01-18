//
//  GoodsViewController.h
//  MiningCircle
//
//  Created by ql on 2016/12/5.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCenterViewController.h"
#import "BackButtonViewController.h"
#import "GoodsModel.h"
@interface GoodsViewController : BackButtonViewController
@property (nonatomic, retain) NSString *catId;
@property (nonatomic, retain) NSString *goodsId;
@property (nonatomic, retain) GoodsModel *model;
@end
