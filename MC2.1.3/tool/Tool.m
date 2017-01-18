//
//  Tool.m
//  MiningCircle
//
//  Created by ql on 15/12/28.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "Tool.h"
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import "PwdEdite.h"
#import "DataManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "NSString+Exten.h"
//#import <ShareSDKUI//ShareSDK+SSUI.h>

@implementation Tool

+(Tool *)shareInstance
{
    static Tool *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Tool alloc]init];
    });
    return _instance;
}
/*
 *网络图片转化为图片
 */
+(UIImage *)changeToImge:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    return img;
    
}
/*
 *分享链接的分割
 */
+(NSArray *)getShareParams:(NSString *)strUrl
{
    //截取编码部分
    if([strUrl rangeOfString:@"#callapp="].location != NSNotFound)
    {
        NSRange range = [strUrl rangeOfString:@"#callapp="];
        NSString *subStr = [strUrl substringFromIndex:NSMaxRange(range)];
            //解码
            subStr = [subStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"`¿"];
            NSArray *arr = [subStr componentsSeparatedByCharactersInSet:character];
         //   NSLog(@"arr-----%@",arr);
            return arr;
    }
    else
    {
        return nil;
    }
}
//#pragma -mark 获得通讯录
-(void)getAddressBook:(void(^)(NSArray * addressArray))addressBlock
{
   /*
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted)
    {
        NSLog(@"AVAuthorizationStatusRestricted");
    }
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        NSLog(@"AVAuthorizationStatusAuthorized");
    }
    */
    
    //获得本地通讯录名柄
   // NSMutableArray *mutArr = [NSMutableArray array];
    ABAddressBookRef addressBook = nil;
    if([[UIDevice currentDevice].systemVersion floatValue]>= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
      //  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
          //  dispatch_semaphore_signal(sema);
            
            if(granted)
            {
                NSArray *arr = [self getAddress:addressBook];
                addressBlock(arr);
            }
            else
            {
                addressBlock(nil);
            }
        });
       // dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW);
    }
   else
   {
       addressBlock(nil);
   }
}
-(NSArray *)getAddress:(ABAddressBookRef)addressBook
{
    NSMutableArray *mutArr = [NSMutableArray array];
    //取得本地所有联系人记录
    NSArray *tmpPeoples = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id tmpPerson in tmpPeoples) {
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        int count = (int)ABMultiValueGetCount(tmpPhones);
        for (int i = 0; i < count; i++) {
            NSString *tmpPhoneIndex = (__bridge NSString *)ABMultiValueCopyValueAtIndex(tmpPhones, i);
            //移除所有非数字的字符
            NSString * str4 = [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, tmpPhoneIndex.length)];
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty));
            if(firstName.length > 0)
            {
                if(lastName == nil)
                {
                    lastName = firstName;
                }
                else
                {
                    lastName = [lastName stringByAppendingString:firstName];
                }
            }
            if(str4.length > 0)
            {
                if(!lastName||lastName.length <= 0)
                {
                    NSDictionary *dict = @{@"userName":@"",@"phoneNum":str4};
                    [mutArr addObject:dict];
                }
                else
                {
                    NSDictionary *dict = @{@"userName":lastName,@"phoneNum":str4};
                    [mutArr addObject:dict];
                }
            }
            
        }
    }
    return mutArr;

}
/*
 *写入文件
 */
+(void)writeToFile:(id)obj
{
    NSDictionary *dataDict = (NSDictionary *)obj;
    //把图片存起来
    NSString *pathsandox = NSHomeDirectory();
    NSString *newPath = [pathsandox stringByAppendingPathComponent:@"/Documents/pic.plist"];
    //写入plist文件
    if ([dataDict writeToFile:newPath atomically:YES]) {
        NSLog(@"写入成功");
    };
    
}

+(void)deleteFile:(NSString *)path
{
    NSString *pathsandox = NSHomeDirectory();
    NSString *userid = [DEFAULT objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",pathsandox,userid];
//写入plist文件
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
//        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
        return;
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@/%@.plist",pathsandox,userid,path];
    if([fileManager removeItemAtPath:plistPath error:nil])
    {
        NSLog(@"删除成功");
    }
}
+(void)writeToFile:(id)obj withPath:(NSString *)path
{
    NSString *pathsandox = NSHomeDirectory();
    NSString *userid = [DEFAULT objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",pathsandox,userid];
    //写入plist文件
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@/%@.plist",pathsandox,userid,path];
    if ([obj writeToFile:plistPath atomically:YES]) {
        NSLog(@"写入成功");
    };

}
+(NSArray *)readFileFromPath:(NSString *)fileName
{
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@/%@.plist",pathsandox,userid,fileName];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:newPath];
//    cellArr = [[NSMutableArray alloc]initWithArray:arr];
    
    return arr;
}
+(NSDictionary *)readDictFromPath:(NSString *)fileName
{
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@/%@.plist",pathsandox,userid,fileName];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:newPath];
    //    cellArr = [[NSMutableArray alloc]initWithArray:arr];
    
    return dict;
}
/*
 中文按字母排序
 为了索引，得按字母分组。
 */
+(NSDictionary *)sort:(NSArray *)arr sortKey:(NSString *)key
{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
        NSString *name = mutDict[key];
        if ([name length]) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:name];
            //转成拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
              //  NSLog(@"pinyin: %@", ms);
            }
            //转成英语
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
              //  NSLog(@"pinyin: %@", ms);
            }
            [mutDict setObject:ms forKey:@"en"];
            [mutArr addObject:mutDict];
        }
        
    }
    //排序
    NSArray *sortArr = [mutArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1[@"en"];
        NSString *str2 = obj2[@"en"];
        if([str1 localizedCompare:str2] > 0)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    //按首字母分组
    NSMutableArray *sectionArr = [NSMutableArray array];
    NSMutableArray *resultArr = [NSMutableArray array];
    NSMutableArray *tagArr = [NSMutableArray array];
    for (int i = 0; i < sortArr.count; i++) {
        NSDictionary *dict = sortArr[i];
        NSString *str = dict[@"en"];
        NSString *subStr = [str substringToIndex:1];
     static  NSString *tag;
        if(i == 0)
        {
            tag = subStr;
        }
        if([tag isEqualToString:subStr])
        {
            [sectionArr addObject:dict];
            if(i == sortArr.count -1)
            {
                NSArray *arr = [[NSArray alloc]initWithArray:sectionArr];
            //    NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:arr,tag, nil];
                [resultArr addObject:arr];
                NSString *upperTag = [tag uppercaseString];
                int num = [upperTag characterAtIndex:0];
                if(num > 'Z'||num < 'A')
                {
                    upperTag = @"#";
                }
                [tagArr addObject:upperTag];
                break;
            }
            
        }
        else
        {
            NSArray *arr = [[NSArray alloc]initWithArray:sectionArr];
            [resultArr addObject:arr];
            NSString *upperTag = [tag uppercaseString];
            //NSString to ASCLL
            int num = [upperTag characterAtIndex:0];
            if(num > 'Z'||num < 'A')
            {
                upperTag = @"#";
            }
            
            [tagArr addObject:upperTag];
             tag = subStr;
            [sectionArr removeAllObjects];
            [sectionArr addObject:dict];
            if(i == sortArr.count -1)
            {
                NSArray *arr1 = [[NSArray alloc]initWithArray:sectionArr];
                [resultArr addObject:arr1];
                NSString *upperTag = [tag uppercaseString];
                int num = [upperTag characterAtIndex:0];
                if(num > 'Z'||num < 'A')
                {
                    upperTag = @"#";
                }
                [tagArr addObject:upperTag];
                break;
            }

        }
        
    }
    NSDictionary *resultDict = @{@"tag":tagArr,@"sec":resultArr};
    return resultDict;
}
+ (UIColor *)colorFromHexRGB:(NSString *)hexColor :(CGFloat)alpha
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

/**
 *一键分享
 */
+(void)share:(NSArray *)params controller:(BannerDetailViewController *)theController
{
    NSInteger platform = SSDKPlatformSubTypeWechatSession;
    NSString *title = @"矿业圈";
    NSString *content = @"百万红包大派送";
    UIImage *img = [UIImage imageNamed:@"shareimgae"];
    NSString *url1 = @"http://miningcircle.com/gt.do?idx";
    //参数
    if(params.count > 8)
    {
        NSString *str = params[1];
        if([str isEqualToString:@"cweixin"])
        {
            platform = SSDKPlatformSubTypeWechatTimeline;
        }
        else if ([str isEqualToString:@"fweixin"])
        {
            platform = SSDKPlatformSubTypeWechatSession;
        }
        else if ([str isEqualToString:@"weibo"])
        {
            platform = SSDKPlatformTypeSinaWeibo;
        }
        title = params[3];
        NSString *ico = params[5];
        img = [Tool changeToImge:ico];
        if(img == nil)
        {
            img = [UIImage imageNamed:@"shareimgae"];
        }

        url1 = params[9];
        content = params[7];
    }
    else if (params.count == 2)
    {
        NSDictionary *dict = params[1];
        if(dict.count > 0)
        {
            title = dict[@"title"];
            content = dict[@"content"];
            NSString *imgurl = dict[@"img"];
            if(imgurl.length > 0)
            {
                img = [Tool changeToImge:imgurl];
                if(img == nil)
                {
                    img = [UIImage imageNamed:@"shareimgae"];
                }

            }
            url1 = dict[@"url"];
        }
    }
    //如果登陆，路径带用户名和手机号。
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *usermobile = [userDefault objectForKey:@"usermobile"];
    NSString *userrealname = [userDefault objectForKey:@"userrealname"];
    NSString *username = [userDefault objectForKey:@"username"];
    NSString *nm = userrealname;
    if(nm == NULL)
    {
        nm = @"";
    }
    if(usermobile == NULL)
    {
        usermobile = @"";
    }
    if(nm == nil)
    {
        nm = username;
    }
    
    if([url1 rangeOfString:@"?"].location != NSNotFound)
    {
        url1 = [NSString stringWithFormat:@"%@&fm=%@&nm=%@",url1,usermobile,nm];
    }
    else
    {
        url1 = [NSString stringWithFormat:@"%@?&fm=%@&nm=%@",url1,usermobile,nm];
    }
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:url1];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if(platform != SSDKPlatformTypeSinaWeibo )
    {
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",content]
                                         images:img
                                            url:url
                                          title:title
                                           type:SSDKContentTypeAuto];
        //分享
        [ShareSDK share:platform
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             
           //  [theController showLoadingView:NO];
           //  [theController.tableView reloadData];
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareSuc")
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"ok"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareFail")
                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                        delegate:nil
                                                               cancelButtonTitle:ZGS(@"ok")
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareCancel")
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:ZGS(@"ok")
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
    else
    {
    //    [shareParams SSDKEnableUseClientShare];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",content,url1]
                                         images:img
                                            url:url
                                          title:title
                                           type:SSDKContentTypeAuto];
        //微博分享（显示内容编辑视图）
        [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo
               otherPlatformTypes:nil
                      shareParams:shareParams
              onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
         {
             
             switch (state) {
                     
                 case SSDKResponseStateBegin:
                 {
                     //[act startAnimating];
                    // [theController showLoadingView:YES];
                     [theController activituStartShow];
                     break;
                 }
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareSuc")
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:ZGS(@"ok")
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareFail")
                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                        delegate:nil
                                                               cancelButtonTitle:ZGS(@"ok")
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareCancel")
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:ZGS(@"ok")
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
             }
             
             if (state != SSDKResponseStateBegin)
             {
                 [theController activityStopShow];
             }
         }];
    }

}
#pragma -mark 获取当前手机语言系统
+(NSString *)getPreferredLanguage
{
  //  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lg = [DEFAULT objectForKey:@"languageset"];
    if(lg == nil)
    {
        NSArray *languageArr = [DEFAULT objectForKey:@"AppleLanguages"];
        NSString *preferredLang = languageArr[0];
        if([preferredLang rangeOfString:@"en"].location!= NSNotFound)
        {
            preferredLang = @"en";
        }
        else
        {
            preferredLang = @"zh-Hans";
        }
        lg = preferredLang;
    }
    return lg;
    
}
+(NSString *)judgeNil:(NSString *)str
{
    if(str.length == 0)
    {
        str = @"";
    }
    return str;
}
+(CGFloat)getLabelHight:(UIFont *)fontSize
{
    NSString *str = @"我";
    CGSize size = [str getStringSize:fontSize width:100];
    return size.height;
}
+(NSDictionary *)replaceNull:(NSDictionary *)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if(data)
    {
        jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *str1 = [jsonString stringByReplacingOccurrencesOfString:@": null" withString:@":\"\""];
        NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"^_^=%@",newDict);
        return newDict;
    }
    return nil;
}

@end
