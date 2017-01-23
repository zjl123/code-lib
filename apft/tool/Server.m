

//
//  Server.m
//  MiningCircle
//
//  Created by ql on 2017/1/23.
//  Copyright © 2017年 zjl. All rights reserved.
//

#import "Server.h"
#import "DataManager.h"
#import "JPUSHService.h"
@implementation Server
{
    NSString *time;
}
+(Server *)shareInstance
{
    static Server *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Server alloc]init];
    });
    return _instance;
}
-(void)getMessage:(NSString *)userid
{
    __block NSMutableArray *message = nil;
    NSString *pathsandox = NSHomeDirectory();
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@/time.plist",pathsandox,userid];
    NSDictionary *timeDict = [[NSDictionary alloc]initWithContentsOfFile:newPath];
    NSString *postTime = timeDict[@"time"];
    if(postTime == nil)
    {
        postTime = @"0";
    }
    
    NSDictionary *paretemers = [[NSDictionary alloc]initWithObjectsAndKeys:@"getmsg",@"cmd",@"iOS",@"os",userid,@"userid",postTime,@"t", nil];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paretemers isPost:YES result:^(NSDictionary *resultBlock) {
        message = [resultBlock objectForKey:@"msglist"];
        if(message.count > 0)
        {
            NSMutableArray *mutArr = [NSMutableArray array];
            for (int i = 0; i < message.count; i++) {
                NSDictionary *dict = message[i];
                NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mutdict setObject:@"1" forKey:@"tag"];
                [mutArr addObject:mutdict];
            }
            [DEFAULT setObject:message forKey:@"messasge"];
            
            NSInteger oldNum = [[DEFAULT objectForKey:@"msgcount"] integerValue];
            NSInteger newNum = oldNum+message.count;
            NSString *num = [NSString stringWithFormat:@"%ld",newNum];
            [DEFAULT setObject:num forKey:@"msgcount"];
            
            time = resultBlock[@"t"];
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:mutArr];
            [thread start];
            NSString *str = @"login";
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:str,@"login",mutArr,@"msg", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict];
            NSInteger aNum = [[UIApplication sharedApplication] applicationIconBadgeNumber];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:aNum+message.count];
            [JPUSHService setBadge:aNum+message.count];
        }
    }];
}
-(void)thread:(id)obj
{
    NSMutableArray *dataDict =  [NSMutableArray arrayWithArray:obj];
    //把图片存起来
    NSString *pathsandox = NSHomeDirectory();
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *userid = [userDefault objectForKey:@"userid"];
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",pathsandox,userid];
    //写入plist文件
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@/msg.plist",pathsandox,userid];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:plistPath];
    [dataDict addObjectsFromArray:arr];
    if ([dataDict writeToFile:plistPath atomically:YES]) {
        NSLog(@"写入成功");
    };
    //写入时间
    NSDictionary *timeDict = @{@"time":time};
    NSString *timePath = [NSString stringWithFormat:@"%@/Documents/%@/time.plist",pathsandox,userid];
    if ([timeDict writeToFile:timePath atomically:YES]) {
        NSLog(@"写入成功");
        
    };
}
#pragma loginout
-(void)loginout:(UIViewController *)vc
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *paramers = [[NSDictionary alloc]initWithObjectsAndKeys:@"logout",@"cmd",nil];
    
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            if([resultBlock count] > 0 && [[resultBlock objectForKey:@"ret"] intValue] == 0)
            {
                
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"logoutSuc") delegate:vc cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                [av show];
               // av.delegate = self;
                av.tag = 500;
                NSString *str = @"0";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cart" object:str];
                [userDefault setInteger:3 forKey:@"autoLogin"];
                [userDefault setInteger:0 forKey:@"login"];
                [userDefault removeObjectForKey:@"entryptPwd"];
                [userDefault removeObjectForKey:@"username"];
                [userDefault removeObjectForKey:@"usercat"];
                [userDefault removeObjectForKey:@"tk"];
                [userDefault removeObjectForKey:@"IMToken"];
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"login",@[],@"msg", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:dict];
                //  NSInteger oldNum = [[userDefault objectForKey:@"msgcount"] integerValue];
                [userDefault setObject:@"0" forKey:@"msgcount"];
                // NSInteger aNum = [[UIApplication sharedApplication]applicationIconBadgeNumber];
                
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
                [JPUSHService setBadge:0];
                
            }
            else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"logoutAgain") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
                av.tag = 505;
                [av show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"exception") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
            [alert show];
        }
        
    }];
    
}



@end
