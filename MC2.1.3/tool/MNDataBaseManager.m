//
//  MNDataBaseManager.m
//  MiningCircle
//
//  Created by ql on 2016/10/17.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "MNDataBaseManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import <RongIMKit/RongIMKit.h>

@interface MNDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end
@implementation MNDataBaseManager

static NSString *const userTableName = @"USERTABLE";
static NSString *const friendTableName = @"FRIENDSTABLE";

+(MNDataBaseManager *)shareInstance
{
    static MNDataBaseManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class]alloc]init];
        [instance dbQueue];
    });
    return instance;
}
-(FMDatabaseQueue *)dbQueue
{
    NSString *userId = [DEFAULT objectForKey:@"userid"];
    if(userId.length == 0)
    {
        return nil;
    }
    if(!_dbQueue)
    {
      //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSLog(@"ppppp%@",paths);
        NSString *documentDirectory = paths[0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DB%@",userId]];
        NSLog(@"dbpath%@",dbPath);
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if(_dbQueue)
        {
            [self creatUserTableIfNeed];
        }
    }
    return _dbQueue;
}
-(void)creatUserTableIfNeed
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if(![self isTabkeOK:friendTableName withDB:db])
        {
            NSString *createTableSQL = @"CREATE TABLE FRIENDSTABLE (id integer PRIMARY KEY autoincrement, userid text,name text,portraitUrl text,status text,updataAt text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_friendsID ON FRIENDSTABLE(userid)";
            [db executeUpdate:createIndexSQL];
        }
        else if (![self isColumnExist:@"name" inTable:friendTableName withDB:db])
        {
            [db executeUpdate:@"ALTER TABLE FRIENDSTABLE ADD COLUMN NAME text"];
        }
    }];
}
#pragma -mark 储存好友数据
//-(void)insertFriendToDB:(IMUserModel *)friendInfo
//{
//    NSString *insertSQL = @"REPLACE INTO FRIENDSTABLE (userid,name,portraitUrl,status,updataAt) VALUES (?,?,?,?,?)";
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSQL,friendInfo.userId,friendInfo.name,friendInfo.portraitUri,friendInfo.status,friendInfo.updatedAt];
//    }];
//}
-(BOOL)isTabkeOK:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isOK = NO;
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where " @"type = 'table' and name = ?",tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        if(0 == count)
        {
            isOK = NO;
        }
        else
        {
            isOK = YES;
        }
        
    }
    return isOK;
}
-(BOOL)isColumnExist:(NSString *)column inTable:(NSString *)tableName withDB:(FMDatabase*)db
{
    BOOL isExit = NO;
    NSString *columnQurerySql = [NSString stringWithFormat:@"SELECT %@ from %@",column,db];
    FMResultSet *rs = [db executeQuery:columnQurerySql];
    if([rs next])
    {
        isExit = YES;
    }else
    {
        isExit = NO;
    }
    [rs close];
    return isExit;
}
@end
