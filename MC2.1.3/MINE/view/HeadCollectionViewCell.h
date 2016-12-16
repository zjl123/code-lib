//
//  HeadCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UpDownBtn1.h"
#import "Horizontal.h"
@protocol LogDelegate <NSObject>

-(void)jumpLogin;
-(void)headBtnJump:(NSString*)url;

@end
@interface HeadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *unLogBg;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *useableLabel;
@property (weak, nonatomic) IBOutlet UILabel *yProfileLabel;

- (IBAction)btnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *loginbg;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UILabel *unLogLabel;
@property (weak, nonatomic) IBOutlet Horizontal *btn1;
@property (weak, nonatomic) IBOutlet Horizontal *btn2;
@property (weak, nonatomic) IBOutlet Horizontal *btn3;
@property (weak, nonatomic) IBOutlet UIView *whiteline1;
@property (weak, nonatomic) IBOutlet UIView *whiteline2;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *totalAsset;
@property (weak, nonatomic) IBOutlet UILabel *useableAsset;
@property (weak, nonatomic) IBOutlet UILabel *profile;
@property (weak, nonatomic) IBOutlet UILabel *totalFrofile;
@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,retain) NSArray *btnInfo;
@property (weak, nonatomic) IBOutlet UIView *tipLoginView;
@property (assign,nonatomic) BOOL isLogin;
@property (nonatomic,strong) id <LogDelegate>delegate;
- (IBAction)loginn:(id)sender;
@end
