//
//  UINavigationController+back.h
//  MiningCircle
//
//  Created by ql on 2017/1/20.
//  Copyright © 2017年 zjl. All rights reserved.
//



@interface UINavigationController (back)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item;
@end
