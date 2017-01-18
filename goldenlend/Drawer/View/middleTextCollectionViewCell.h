//
//  middleTextCollectionViewCell.h
//  MiningCircle
//
//  Created by ql on 2016/10/31.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogoutDelegate <NSObject>

-(void)LogoutGroup;

@end
@interface middleTextCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleAndLogout;
@property (weak, nonatomic) id<LogoutDelegate>logoutDelegate;
- (IBAction)DeleCLick:(id)sender;

@end
