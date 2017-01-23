//
//  ShowTextViewController.h
//  MiningCircle
//
//  Created by ql on 16/9/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) NSString *msg;
@end
