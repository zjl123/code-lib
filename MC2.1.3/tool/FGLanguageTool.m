
//
//  FGLanguageTool.m
//  MiningCircle
//
//  Created by ql on 16/8/18.
//  Copyright © 2016年 zjl. All rights reserved.
//

#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"languageset"
#define TABLE @"Localizable"
#import "AppDelegate.h"
#import "FGLanguageTool.h"
#import "MyTabBarViewController.h"
#import "Tool.h"

static FGLanguageTool *shareModel;

@interface FGLanguageTool ()

@property (nonatomic,strong) NSBundle *bundle;
@property (nonatomic,copy) NSString *language;

@end
@implementation FGLanguageTool

+(id)sharedInstance
{
    if(!shareModel)
    {
        shareModel = [[FGLanguageTool alloc]init];
        NSLog(@"111");
    }
    return shareModel;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initLanguage];
    }
    return self;
}

-(void)initLanguage
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    NSString *path;
       //默认中文
    if(!tmp)
    {
        NSString *prefrredLang = [Tool getPreferredLanguage];

        if([prefrredLang rangeOfString:@"en"].location != NSNotFound)
        {
            tmp = EN;
        }
        else
        {
            tmp = CNS;
        }
    }
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

-(NSString *)getStringForKey:(NSString *)key
{
    //NSLog(@"%@",self.bundle);
    if(self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, TABLE, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, TABLE, @"");
}

//-(void)changeNowLanguage:(NSString *)langStr
//{
//    
//    if([self.language isEqualToString:EN])
//    {
//        [self setNewLanguage:CNS];
//    }
//    else
//    {
//        [self setNewLanguage:EN];
//    }
//    
//}

-(void)setNewLanguage:(NSString *)language
{
    if([language isEqualToString:self.language])
    {
        return;
    }
    if([language isEqualToString:EN] || [language isEqualToString:CNS])
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
    
}
//重置RootController
-(void)resetRootViewController
{
  //  NSLog(@"777");
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
    [userDefaut setObject:@"0" forKey:@"postTime"];
    [appDelegate changeMenu];
   MyTabBarViewController *myTabBar=[[MyTabBarViewController alloc]init];
    //移除tabbar上controller所有的监听
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myTabBar];
    [nav.navigationBar setBarTintColor:BLUECOLOR];
    myTabBar.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:myTabBar selector:@selector(response2:) name:@"tabbarmenu" object:nil];
    appDelegate.window.rootViewController = nav;
    
}
@end
