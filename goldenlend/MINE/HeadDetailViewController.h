//
//  HeadDetailViewController.h
//  MiningCircle
//
//  Created by ql on 16/3/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
@interface HeadDetailViewController : BackButtonViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (retain,nonatomic)NSString *imgUrl;
@property(retain,nonatomic)NSString *name;
@property(retain,nonatomic)NSString *address;
@property(retain,nonatomic)UIImage *img;
@property (retain, nonatomic) NSString *targetId;
@property (assign, nonatomic)BOOL isPost;
@property (retain, nonatomic)NSString *picLine;
-(void)selectedImage;
-(void)sendGroupPic:(NSString *)line andGroupId:(NSString *)groupId;
@end
