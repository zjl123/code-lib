//
//  HeaderCollectionReusableView.h
//  MiningCircle
//
//  Created by ql on 15/12/30.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgButton.h"
@protocol editDelegate <NSObject>

-(void)edit:(int)num :(ImgButton *)sender;

@end
@interface HeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
- (IBAction)edit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,strong) id <editDelegate> delegate;
@property (nonatomic,assign)int num;
@end
