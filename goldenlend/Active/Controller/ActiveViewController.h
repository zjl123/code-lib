//
//  ActiveViewController.h
//  MiningCircle
//
//  Created by zhanglily on 15/7/30.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ActiveViewController : BaseViewController
-(void)response:(NSNotification *)n;
@property(nonatomic,retain)NSString *strUrl;
@end
