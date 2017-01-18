//
//  RCIMDataSource.m
//  MiningCircle
//
//  Created by ql on 2016/10/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "RCIMDataSource.h"
#import "Tool.h"
#import "DataManager.h"
#import "RCDUtilities.h"
#import "PwdEdite.h"
@implementation RCIMDataSource

-(void)syncGroup
{
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
  //  AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *geturl = [NSString stringWithFormat:@"%@rongyun.do?groupSync&userId=%@",MAINURL,hostId];
    [[DataManager shareInstance]ConnectServer:geturl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        
    }];
}
+(RCIMDataSource *)shareInstance
{
    static RCIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance  = [[[self class] alloc]init];
    });
    return instance;
}
#pragma -mark RCIMUserInfoDataSource
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSString *hostId = [DEFAULT objectForKey:@"userid"];
    if([userId isEqualToString:hostId])
    {
        NSString *hostName = [DEFAULT objectForKey:@"username"];
        NSString *hostImg = [DEFAULT objectForKey:@"headImg"];
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:hostName portrait:hostImg];
        return completion(userInfo);
        
    }
//    if([userId isEqualToString:@"__system__"])
//    {
//        //客服
//        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:ZGS(@"IMSystemMsg") portrait:@"https://img.sobot.com/console/common/face/robot.png"];
//        
//        return completion(userInfo);
//    }
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    for (NSDictionary *dict in mutArr) {
        if([dict[@"userId"] isEqualToString:userId])
        {
            NSString *showName = dict[@"nameRemark"];
            if(!showName||showName.length == 0)
            {
                showName = dict[@"userName"];
            }
            RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:showName portrait:dict[@"userImg"]];
            return completion(userInfo);
            
        }
    }
    [self getInfoByuserId:userId result:^(NSDictionary *userInfo) {
        NSString *showName = userInfo[@"nameRemark"];
        if(!showName||showName.length == 0)
        {
            showName = userInfo[@"userName"];
        }
        RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:userInfo[@"userId"] name:showName portrait:userInfo[@"userImg"]];
        return completion(info);
    }];

}
-(void)getGroupInfoFromServer:(NSString *)groupId resultBlock:(void(^)(IMGroupModel * groupBlock))completion
{
    //没找到的话到服务器找
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *userid = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?groupInfo&groupId=%@&userId=%@",MAINURL,groupId,userid];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if(resultBlock.count <= 0)
        {
            completion(nil);
        }
        //  NSLog(@"%@",dict);
        NSDictionary *result = resultBlock[@"groupInfo"];
        if(result.count > 0)
        {
            IMGroupModel *model = [[IMGroupModel alloc]initWithDictionary:result];
            NSDictionary *dict = resultBlock[@"userCount"];
            if(dict.count  > 0)
            {
                model.maxNum = [dict[@"userCount"] integerValue];
            }
            //存
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(saveGroupInfo:) object:result];
            [thread start];
            completion(model);
        }
        else
        {
            completion(nil);
        }

    }];
}
#pragma -mark RCIMGroupInfoDataSource
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    NSMutableArray *groupArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"groupInfo"]];
    for (NSDictionary *dict in groupArr) {
        if([dict[@"groupId"] isEqualToString:groupId])
        {
            RCGroup *group = [[RCGroup alloc]init];
            group.groupName = dict[@"groupName"];
            NSString *imgUrl = dict[@"groupImg"];
            group.portraitUri = imgUrl;
            if(imgUrl.length <= 0 || !imgUrl)
            {
             group.portraitUri = [RCDUtilities defaultGroupPortrait:group];
            }
            
            return completion(group);
            
        }
    }
    [self getGroupInfoFromServer:groupId resultBlock:^(RCGroup *groupBlock) {
        if(groupBlock.portraitUri.length <= 0 || !groupBlock.portraitUri)
        {
            groupBlock.portraitUri = [RCDUtilities defaultGroupPortrait:groupBlock];
        }
    return  completion(groupBlock);
    }];
}
#pragma -mark RCIMGroupUserInfoDataSource
-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion
{
    if([userId isEqualToString:@"__system__"])
    {
        RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:@"群组通知" portrait:nil];
      return completion(user);
    }
    NSArray *arr = [Tool readFileFromPath:groupId];
    NSString *name;
    NSString *imgUrl;
    for (NSDictionary *dict in arr) {
        if([dict[@"userId"] isEqualToString:userId])
        {
            name = dict[@"userName"];
            imgUrl = dict[@"userImg"];
            NSString *remark = dict[@"nameRemark"];
            if(remark.length > 0)
            {
                name = remark;
            }
            RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:imgUrl];
            return completion(userInfo);
        }
        

    }
   [self getInfoByuserId:userId result:^(NSDictionary *userInfo) {
       RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:userInfo[@"userName"] portrait:userInfo[@"userImg"]];
       return completion(user);
   }];
    
}
#pragma -mark RCIMGroupMemberDataSource
-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))result
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSDictionary *dict = [Tool readDictFromPath:@"time"];
    NSString *lastTime = dict[groupId];
    if(lastTime == nil)
    {
        lastTime = @"0";
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findGroupUsers&groupId=%@&lastAccessTime=%@",MAINURL,groupId,lastTime];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            NSArray *arr = resultBlock[@"groupUserList"];
            if(arr.count > 0)
            {
                [[RCIM sharedRCIM]clearGroupUserInfoCache];
                //存
                NSDictionary *dict = @{groupId:arr};
                NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(groupInfoThread:) object:dict];
                [thread start];
            }
            else
            {
                //取
                arr = [Tool readFileFromPath:groupId];
            }
            result(arr);
        }
        else
        {
            NSArray *arr = [Tool readFileFromPath:groupId];
            result(arr);

        }
    }];
    
//    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//     //   NSLog(@"groupMember...%@",dict);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSArray *arr = [Tool readFileFromPath:groupId];
//        resultBlock(arr);
//    }];

}

#pragma -mark 自定义方法（一下都是）
#pragma -mark 获取通讯录
-(void)getAddressBook:(void(^)(NSDictionary *addressDict))addressBlock
{
    NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    NSString *postTime = timeDict[@"lastAccessTime"];
    if(postTime == nil)
    {
        postTime = @"0";
    }
    NSString *userid = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findUserAllFriend&userId=%@&lastAccessTime=%@",MAINURL,userid,postTime];
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        if(resultBlock)
        {
            if(resultBlock.count > 0)
            {
                NSArray *friendArr = resultBlock[@"allFriend"];
                if(friendArr.count > 0)
                {
                  //  [[RCIM sharedRCIM]clearUserInfoCache];
                    NSNumber *lastTime = resultBlock[@"lastAccessTime"];
                    if(lastTime)
                    {
                        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:lastTime];
                        [thread start];
                        
                    }
                    //写入文件(好友)
                    NSThread *thread1 =  [[NSThread alloc]initWithTarget:self selector:@selector(write:) object:friendArr];
                    [thread1 start];
                }
                //群
                NSArray *groupArr = resultBlock[@"allGroup"];
                if(groupArr.count > 0)
                {
                  //  [[RCIM sharedRCIM]clearGroupInfoCache];
                    NSThread *groupThread = [[NSThread alloc]initWithTarget:self selector:@selector(groupThread:) object:groupArr];
                    [groupThread start];
                }
            }
            addressBlock(resultBlock);
        }
        else
        {
            addressBlock(nil);
        }
    }];
    
//    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//     //   NSLog(@"%@",dict);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        addressBlock(nil);
//    }];

}
//刷新数据，从服务器取，服务器没有本地取
-(NSArray *)refreshFriendDataby:(NSString *)userId
{
 //  __block  NSArray *friendArr;
    [self getAddressBook:^(NSDictionary *addressDict) {
       NSArray *friendArr = addressDict[@"allFriend"];
        if(friendArr.count <= 0||!friendArr)
        {
            friendArr = [Tool readFileFromPath:@"friend"];
        }
    }];
    
    return nil;
}
#pragma -mark 存群
-(void)groupThread:(NSArray *)arr
{
    //NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"groupInfo"]];
    // [mutArr addObject:arr];
    [Tool writeToFile:arr withPath:@"groupInfo"];
}
#pragma -mark 存时间
-(void)thread:(id)time
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[Tool readDictFromPath:@"time"]];
    
    [mutDict setObject:time forKey:@"lastAccessTime"];
    [Tool writeToFile:mutDict withPath:@"time"];
}
-(void)write:(NSArray *)obj
{
    [Tool writeToFile:obj withPath:@"friend"];
}

#pragma -mark group存
-(void)groupInfoThread:(NSDictionary *)groupDict
{
    NSString *key = groupDict.allKeys[0];
    [Tool writeToFile:groupDict[key] withPath:key];
}
//本地没有就到服务器请求
-(NSArray *)getAllFriendInfo
{
  __block NSArray *arr = [Tool readFileFromPath:@"friend"];
    if(arr.count == 0)
    {
        [self getAddressBook:^(NSDictionary *addressDict) {
            arr = addressDict[@"allFriend"];
        }];
    }

    return arr;
}
//本地没有就到服务器请求
-(NSArray *)getAllGroupInfo
{
    __block NSArray *arr = [Tool readFileFromPath:@"groupInfo"];
    if(arr.count == 0)
    {
     [self getAddressBook:^(NSDictionary *addressDict) {
         arr = addressDict[@"allGroup"];
     }];
    }
    return arr;
}
-(NSArray *)getRequestFriendInfo
{
    NSArray *arr = [Tool readFileFromPath:@"requestFriend"];
    return arr;
}
//服务器查找好友
-(void)getInfoByuserId:(NSString *)userId result:(void(^)(NSDictionary * userInfo))userBlock
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    //查找好友（根据id）
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?findFriend&userId=%@",MAINURL,userId];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSArray *arr = resultBlock[@"friends"];
        if(arr.count > 0)
        {
            NSDictionary *dict1 = arr[0];
            if(dict1.count > 0)
            {
                userBlock(dict1);
            }
            
        }
    }];
    
    
//    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        dict = [PwdEdite decoding:dict];
//      //  NSLog(@"dict%@",dict);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//
}
-(IMUserModel *)getUserModelByUserId:(NSString *)userId
{
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    //  NSDictionary *userDict;
    for (NSDictionary *dict in mutArr) {
        if([dict[@"userId"] isEqualToString:userId])
        {
            IMUserModel *model = [[IMUserModel alloc]initWithDictionary:dict];
            return model;
            
        }
    }
    return nil;

}
//存单个群信息
-(void)saveGroupInfo:(NSDictionary *)dict
{
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"groupInfo"]];
    BOOL isExit = NO;
    for (int i = 0; i < mutArr.count; i++) {
        NSDictionary *infoDict = mutArr[i];
        if([dict[@"groupId"] isEqualToString:infoDict[@"groupId"]])
        {
            [mutArr replaceObjectAtIndex:i withObject:dict];
            isExit = YES;
            break;
        }
    }
    if(!isExit)
    {
        [mutArr addObject:dict];
    }
    [Tool writeToFile:mutArr withPath:@"groupInfo"];
}
-(NSArray *)getAllMembersFromLocalbyGroupId:(NSString *)groupId
{
    NSArray *arr = [Tool readFileFromPath:groupId];
    return arr;
}
@end
