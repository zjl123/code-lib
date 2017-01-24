//
//  HeadDetailViewController.h
//  MiningCircle
//
//  Created by ql on 16/3/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButtonViewController.h"
#import "HudView.h"
@interface HeadDetailViewController : BackButtonViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (retain,nonatomic)NSString *imgUrl;
@property(retain,nonatomic)NSString *name;
@property(retain,nonatomic)NSString *address;
@property(retain,nonatomic)UIImage *img;
@property (retain, nonatomic) NSString *targetId;
@property (assign, nonatomic)BOOL isPost;
/**
 * 创建时群头像链接
 **/
@property (retain, nonatomic)NSString *picLine;
/**
 *修改群头像的图片链接
 **/
@property (retain, nonatomic)NSString *modifyLine;
-(void)selectedImage;
-(void)sendGroupPic:(NSString *)line andGroupId:(NSString *)groupId;
-(void)showSuccessView;
-(void)loadHudView;
@end
