//
//  ShareView.m
//  MiningCircle
//
//  Created by zhanglily on 15/8/17.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDKUI//ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <Social/Social.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "ShareCollectionview.h"
@implementation ShareView
{
    
    UIView *blackView;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
       // self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
      //  self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)share:(NSArray *)params controller:(UIViewController *)controller
{
  //  NSArray *ImgArr = @[@"sns_icon_23",@"sns_icon_23",@"sns_icon_23",@"sns_icon_23",@"sns_icon_23",@"sns_icon_23"];
  
    //参数
    
    NSString *title = @"矿业圈";
    NSString *content = @"百万红包大派送";
    UIImage *img = [UIImage imageNamed:@"shareimgae"];
    NSString *url1 = @"http://miningcircle.com/gt.do?idx";
    //参数
    if(params.count > 8)
    {
        title = params[3];
        NSString *ico = params[5];
        if([ico rangeOfString:@"http"].location != NSNotFound)
        {
            img = [Tool changeToImge:ico];
            if(img == nil)
            {
                img = [UIImage imageNamed:@"shareimgae"];
            }
        }
        else
        {
            img = [UIImage imageNamed:ico];
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
                if([imgurl rangeOfString:@"http"].location != NSNotFound)
                {
                    img = [Tool changeToImge:imgurl];
                    if(img == nil)
                    {
                        img = [UIImage imageNamed:@"shareimgae"];
                    }
                }
                else
                {
                    img = [UIImage imageNamed:imgurl];
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
   
    
    //自定义平台
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"more"] label:@"系统分享" onClick:^{
        //   NSLog(@"dedede");
        NSArray *activity = @[title,img,url];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activity applicationActivities:nil];
        [controller presentViewController:activityController animated:YES completion:^{
            
        }];
        
    }];

    NSMutableArray *platforms = [NSMutableArray array];
   //设置平台
    if(params.count > 8)
    {
        NSString *str = params[1];
        if([str isEqualToString:@"weixin"])
        {
            
            NSArray *apiArr =@[@{@"api":@(SSDKPlatformSubTypeWechatSession),@"icon":@"wxtimeline"},@{@"api":@(SSDKPlatformSubTypeWechatTimeline),@"icon":@"wxsession"}];
            [platforms addObjectsFromArray:apiArr];
           // icons = @[@"wxtimeline",@"wxsession"];
        }
        else
        {
            NSArray *apiArr = @[@{@"api":@(SSDKPlatformSubTypeWechatSession),@"icon":@"wxsession"},@{@"api":@(SSDKPlatformSubTypeWechatTimeline),@"icon":@"wxtimeline"},@{@"api":@(SSDKPlatformTypeSinaWeibo),@"icon":@"weibo"},@{@"api":@(SSDKPlatformSubTypeQQFriend),@"icon":@"qq"},@{@"api":@(SSDKPlatformSubTypeQZone),@"icon":@"quze"},@{@"api":item,@"icon":@"more"}];
            [platforms addObjectsFromArray:apiArr];
            if(![WXApi isWXAppInstalled])
            {
                [platforms removeObjectsInRange:NSMakeRange(0, 2)];
                
            }
            NSArray *qqArr;
            if(![QQApiInterface isQQInstalled])
            {
                qqArr = @[@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
                NSInteger length = platforms.count;
                [platforms removeObjectsInRange:NSMakeRange(length-3, 2)];
            }
            
           // icons = @[@"wxsession",@"wxtimeline",@"weibo",@"qq",@"quze",@"more"];
            
        }
    }
    else if(params.count == 2)
    {
        NSArray *apiArr = @[@{@"api":@(SSDKPlatformSubTypeWechatSession),@"icon":@"wxsession"},@{@"api":@(SSDKPlatformSubTypeWechatTimeline),@"icon":@"wxtimeline"},@{@"api":@(SSDKPlatformTypeSinaWeibo),@"icon":@"weibo"},@{@"api":@(SSDKPlatformSubTypeQQFriend),@"icon":@"qq"},@{@"api":@(SSDKPlatformSubTypeQZone),@"icon":@"quze"},@{@"api":item,@"icon":@"more"}];
        [platforms addObjectsFromArray:apiArr];
        if(![WXApi isWXAppInstalled])
        {
            [platforms removeObjectsInRange:NSMakeRange(0, 2)];
            
        }
       // NSArray *qqArr;
        if(![QQApiInterface isQQInstalled])
        {
           // qqArr = @[@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
            NSInteger length = platforms.count;
            [platforms removeObjectsInRange:NSMakeRange(length-3, 2)];
        }
        

    }
    
    
    
   //自定义view
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat blackH = 100;
    if(!blackView)
    {
        blackView = [[UIView alloc]initWithFrame:CGRectMake(0, h,width1, blackH)];
        
        blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:blackView];
        
        //collectionview
        CGFloat collX = w/10;
        CGFloat collH = blackH-20;
        ShareCollectionview *shareCollView = [[ShareCollectionview alloc]initWithFrame:CGRectMake(collX, (blackH-collH)/2, w-collX*2, collH)];
        shareCollView.stateArr = platforms;
        //shareCollView.arr = icons;
        shareCollView.title = title;
        shareCollView.content = content;
        shareCollView.url = url;
        shareCollView.img = img;
        shareCollView.controlller = controller;
        [blackView addSubview:shareCollView];
    }
   [UIView animateWithDuration:0.3f animations:^{
       blackView.frame = CGRectMake(0, h-blackH, w, blackH);
   } completion:^(BOOL finished) {
       self.hidden = NO;
   }];
 }
-(void)tapSelf:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2f animations:^{
        blackView.frame = CGRectMake(0, height1, width1, 100);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma -mark UIGwstureDelegate(手势冲突)
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   // NSLog(@"%@",[touch.view.superview class]);
    if([touch.view.superview isKindOfClass:[UICollectionViewCell class]])
    {
        return NO;
    }
    return YES;
}
@end
