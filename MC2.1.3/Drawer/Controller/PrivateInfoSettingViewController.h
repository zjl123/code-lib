//
//  PrivateInfoSettingViewController.h
//  MiningCircle
//
//  Created by ql on 2016/11/3.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
@interface PrivateInfoSettingViewController : BackButtonViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) NSString *userId;
@end
