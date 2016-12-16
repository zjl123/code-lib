//
//  FGLanguageTool.h
//  MiningCircle
//
//  Created by ql on 16/8/18.
//  Copyright © 2016年 zjl. All rights reserved.
//

#define ZGS(key) [[FGLanguageTool sharedInstance] getStringForKey:key]
#import <Foundation/Foundation.h>

@interface FGLanguageTool : NSObject

+(id)sharedInstance;

/**
 * 返回table中指定的key值
 * @param key key
 * @param table table
 *
 *@return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key;

/**
 *  改变当前语言
 */
//-(void)changeNowLanguage:(NSString*)langStr;

/**
 *  设置新语言
 *
 *  @param langauge 新语言
 */
-(void)setNewLanguage:(NSString *)language;
@end
