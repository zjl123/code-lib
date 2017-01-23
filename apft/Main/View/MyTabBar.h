//
//  MyTabBar.h
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理的另一种写法，并不是一定要建立一个代理的文件
//先把MyTabBar引用出来，才可以用到.
#import "MyTabButton.h"
//#import "ImgButton.h"
@class MyTabBar;

@protocol MyTabBarDelegate <NSObject>

@optional

//代理方法
-(void)tabbar: (MyTabBar *)tabBar didSelectedButtonfrom: (int)from to: (int)to;
//-(void)plusBtnClick: (MyTabBar *)tabBar :(ImgButton *)btn;
@end


@interface MyTabBar : UIImageView
-(void)addTabBarButtonwithItem:(UITabBarItem *)item :(UIColor*)selectedTitleColor;
-(void)btnClick:(UIButton *)btn;
@property(nonatomic,strong)UIColor *selectedTitleColor;
@property(nonatomic,retain)NSString *statues;
//@property(nonatomic,weak)ImgButton *plusButton;
@property(nonatomic,weak)MyTabButton *selectedBtn;
@property(nonatomic,strong)MyTabButton *btn1;
@property(nonatomic,strong)NSMutableArray *tabBarButtons;
@property (nonatomic,retain)id <MyTabBarDelegate> delegate;
@property(nonatomic,assign) BOOL isSelected;
@end
