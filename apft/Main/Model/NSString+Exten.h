//
//  NSString+Exten.h
//  MiningCircle
//
//  Created by ql on 16/5/20.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Exten)
/** 一般的自适应   返回Size */
- (CGSize)getStringSize:(UIFont*)font width:(CGFloat)width;
@end
