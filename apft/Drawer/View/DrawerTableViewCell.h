//
//  LeftTableViewCell.h
//  MiningCircle
//
//  Created by zhanglily on 15/7/21.
//  Copyright (c) 2015年 zjl. All rights reserved.
//  抽屉效果————两侧页面表格行

#import <UIKit/UIKit.h>

@interface DrawerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property(nonatomic,strong)NSDictionary *cellDict;
@property(nonatomic,strong)NSDictionary *redDict;
@end
