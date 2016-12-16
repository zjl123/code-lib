//
//  GroupInfoSettingViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMGroupModel.h"
@interface GroupInfoSettingViewController : UIViewController
@property (retain, nonatomic) NSString *groupId;
//根据groupId获取groupModel
@property (strong, nonatomic) IMGroupModel *groupModel;
@property (strong,nonatomic)NSMutableArray *memArr;

@end
