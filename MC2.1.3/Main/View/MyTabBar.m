//
//  MyTabBar.m
//  MiningCircle
//
//  Created by qianfeng on 15-6-15.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "MyTabBar.h"
#import "MyTabButton1.h"
@interface MyTabBar()

@end
@implementation MyTabBar

//懒加载
-(NSMutableArray *)tabBarButtons
{
    if(_tabBarButtons == nil)
    {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //覆盖掉原来的
        [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
        [[UITabBar appearance]setBackgroundImage:[[UIImage alloc]init]];
    //    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"11"]];
      //  self.backgroundColor = [UIColor yellowColor];
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"tabBarBG"];
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

-(void)addTabBarButtonwithItem:(UITabBarItem *)item :(UIColor *)selectedTitleColor{
    
    NSString *title = item.title;
    if(title.length > 0)
    {
        _btn1=[[MyTabButton alloc]init];
        [self addSubview:_btn1];
        [self.tabBarButtons addObject:_btn1];
        //设置按钮数据,具体设置写在button的类里，这就是封装
           _btn1.item=item;
        //_btn1.selectedTitleColor = selectedTitleColor;
        //点击事件
        [_btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        if(self.tabBarButtons.count == 1)
        {
            [self btnClick:_btn1];
    }
    }
    else
    {
        MyTabButton1 *btn = [MyTabButton1 buttonWithType:UIButtonTypeCustom];
      //  btn.backgroundColor = [UIColor redColor];
        [self addSubview:btn];
        [self.tabBarButtons addObject:btn];
        btn.item = item;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }
}

//显示(view的初始化和布局分开)
-(void)layoutSubviews
{
    [super layoutSubviews];
   // UIPageControl
    CGFloat btnY=2+12;
 //   NSLog(@"%lu",(unsigned long)self.subviews.count);
    CGFloat btnW=self.bounds.size.width/self.subviews.count;
    CGFloat btnH=self.bounds.size.height-14;
    for (int index=0; index<self.tabBarButtons.count; index++) {
        //取出按钮
        UIButton *btn=self.tabBarButtons[index];
        //设置按钮frame
        CGFloat btnX=index*btnW;
        if(index == 2)
        {
          //  btn.backgroundColor = [UIColor yellowColor];
            btn.frame = CGRectMake(btnX, 0, btnW, btnH+12);
        }
        else
        {
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
        btn.tag=index;
           }
}
-(void)btnClick:(UIButton *)btn
{
    //如果代理响应了这个方法
    if([self.delegate respondsToSelector:@selector(tabbar:didSelectedButtonfrom:to:)])
    {
        [self.delegate tabbar:self didSelectedButtonfrom:(int)self.selectedBtn.tag to:(int)btn.tag];
    }
    self.selectedBtn.selected=NO;
    btn.selected=YES;
    self.selectedBtn=btn;

}
@end
