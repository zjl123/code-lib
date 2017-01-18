//
//  Tool.h
//  MiningCircle
//
//  Created by ql on 15/12/28.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerDetailViewController.h"
@interface Tool : NSObject

+(Tool *)shareInstance;
+(UIImage *)changeToImge:(NSString *)str;
+(NSArray *)getShareParams:(NSString *)strUrl;
+(NSMutableArray *)getAddressBook;
-(void)getAddressBook:(void(^)(NSArray * addressArray))addressBlock;
/**排序*/
+(NSDictionary *)sort:(NSArray *)arr sortKey:(NSString *)key;
/*
 *写入文件
 */
+(void)writeToFile:(id)obj;
/*
*传入路径写入文件
 */
+(void)writeToFile:(id)obj withPath:(NSString *)path;
/*
 *(NSarray)传入路径读出文件
 */
+(NSArray *)readFileFromPath:(NSString *)fileName;
/*
 *(NSDictionary)传入路径读出文件
 */
+(NSDictionary *)readDictFromPath:(NSString *)fileName;
/**
 *16进制转RGB
 */
+ (UIColor *)colorFromHexRGB:(NSString *)hexColor :(CGFloat)alpha;
//+(void)share:(NSArray *)params;
+(void)share:(NSArray *)params controller:(BannerDetailViewController *)theController;
+(NSString *)getPreferredLanguage;
/**字符串判空*/
+(NSString *)judgeNil:(NSString *)str;
/**删除文件*/
+(void)deleteFile:(NSString *)path;
/**
 * 判断单行显示label的高度
 */
+(CGFloat)getLabelHight:(UIFont *)fontSize;
/**
 * 替换json里的null
 */
+(NSDictionary *)replaceNull:(NSDictionary *)dict;

@end
