//
//  TableViewCell.h
//  MiningCircle
//
//  Created by ql on 15/12/14.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
