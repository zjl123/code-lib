//
//  IMRCChatViewController.h
//  MiningCircle
//
//  Created by ql on 2016/10/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
@interface IMRCChatViewController : RCConversationViewController
-(void)renameGroupName:(NSNotification *)notify;
-(void)ClearHistoryMsg:(NSNotification *)notify;
@end
