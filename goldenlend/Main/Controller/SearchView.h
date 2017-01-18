//
//  SearchView.h
//  MiningCircle
//
//  Created by ql on 16/2/23.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomField.h"
#import "LocalBtn.h"
#import "BgImgButton.h"
@protocol SearchDelegate <NSObject>

-(void)jumpSearch;
-(void)jumpSearchList:(NSString *)keyWord;
@end

@interface SearchView : UIView
@property(nonatomic,strong)UITextField *searchField;
@property(nonatomic,strong)UIImageView *searchImgView;
@property (nonatomic,strong)BgImgButton *categoryBtn;
@property(nonatomic,strong)id <SearchDelegate>delegate;
@property(nonatomic,retain)UIViewController *controller;
@property (nonatomic,retain)NSString *rescat;
/**
 *到SearchWebController时更新布局
 */
-(void)changeFrame;
/**
 *回到首页的时候布局回复
 */
-(void)rollBack;
/**
 *更新数据
 */
-(void)refreshData;
@end
