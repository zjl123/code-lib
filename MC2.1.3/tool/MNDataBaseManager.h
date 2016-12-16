//
//  MNDataBaseManager.h
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserModel.h"
@interface MNDataBaseManager : NSObject
+(MNDataBaseManager *)shareInstance;
/**存储好友信息*/
-(void)insertFriendToDB:(IMUserModel *)friendInfo;
@end
