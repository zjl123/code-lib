//
//  SuccessHud.h
//  MiningCircle
//
//  Created by ql on 2017/1/16.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessHud : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (retain, nonatomic) NSString *tipText;
@property (retain, nonatomic) NSString *img;
@end
