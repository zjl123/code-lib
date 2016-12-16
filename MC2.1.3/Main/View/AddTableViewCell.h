//
//  AddTableViewCell.h
//  MiningCircle
//
//  Created by ql on 15/12/9.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property(retain,nonatomic)NSDictionary *info;
@property(nonatomic,retain)UIView *redView;
@end
