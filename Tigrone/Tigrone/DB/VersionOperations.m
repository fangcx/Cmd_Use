//
//  VersionOperations.m
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import "VersionOperations.h"
#import "FMDB.h"
#import "DBManager.h"

@implementation VersionOperations

+ (NSString *)getDBVersion
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block NSString *resultStr = nil;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@",T_DB_VERSION];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             resultStr = [rs stringForColumn:@"VersionValue"];
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return resultStr;
}

+ (BOOL)setDBVersion:(NSString *)versionString
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (VersionValue) VALUES ('%@')",T_DB_VERSION,versionString];
         
         result = [db executeUpdate:sql];
         
         if(!result)
         {
             DDLogError(@"setDBVersion is Failed!!!");
         }
     }];
    return result;
}


@end
