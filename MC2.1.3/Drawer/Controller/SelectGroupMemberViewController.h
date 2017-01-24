//
//  SelectGroupMemberViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/24.
//  Copyright © 2016年 zjl. All rights reserved.
//  block 声明，实现，调用

#import <UIKit/UIKit.h>
#import "AddressBookViewController.h"
#import "IMGroupModel.h"
#import "BackButtonViewController.h"
//声明
typedef void(^ReturnDataBlock)(NSDictionary *returnDict);

@interface SelectGroupMemberViewController : BackButtonViewController
/**
 *判断是显示所有好友，还是某个群的所有成员
 */
@property (assign, nonatomic)BOOL isDele;
@property (assign, nonatomic) NSInteger groupMaxNum;
@property (strong, nonatomic) IMGroupModel *groupModel;
@property (retain, nonatomic)NSArray *groupMemberArr;
@property (copy, nonatomic) ReturnDataBlock returnBlock;
-(void)getBlock:(ReturnDataBlock)block;
@end
