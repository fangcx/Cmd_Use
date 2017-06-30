//
//  DBManager.m
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import "DBManager.h"
#import "GlobalData.h"
#import "VersionOperations.h"

/*
 *建表Sql
 */
#define CREATE_VERSION_TABLE @"CREATE TABLE IF NOT EXISTS %@(VersionID integer primary key,VersionValue text)"

#define CREATE_USER_TABLE @"CREATE TABLE IF NOT EXISTS %@(userId TEXT PRIMARY KEY  NOT NULL,userName text,avatarUrlStr text,gender integer)"

#define CREATE_AREA_TABLE @"CREATE TABLE IF NOT EXISTS %@(areaId text primary key,areaName text)"

#define CREATE_CART_TABLE @"CREATE TABLE IF NOT EXISTS %@(cartId text primary key,goodsIcon text,goodsName text,goodsDec text,goodsPrice text,goodsNum integer,userName text,suitCar text,priceFirstDiscount text,maxValue integer)"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
static FMDatabaseQueue *dbQueue;

@implementation DBManager

+(FMDatabaseQueue *)getDBQueue
{
    if (dbQueue)
    {
        return dbQueue;
    }
    @synchronized(self)
    {
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self DBPath]];
    }
    return dbQueue;
}

+(void)reInitDBQueue
{
    @synchronized(self)
    {
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self DBPath]];
    }
}

+ (void)closeDB
{
    [dbQueue close];
}

+ (NSString *)DBPath
{
    //初始化documents目录
    NSString *documentPath = PATH_OF_DOCUMENT;
    //设置用户保存的文件夹
    NSString *userPath = [documentPath stringByAppendingPathComponent:[GlobalData shareInstance].userId];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL userPathExists = [fileManager fileExistsAtPath:userPath];
    if (!userPathExists)
    {
        [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbPath = [userPath stringByAppendingPathComponent:MY_DB_NAME];
    return dbPath;
}

+ (void)initDBSettings
{
    //重新初始化数据库，（更换用户后数据库路径会改变，需要重新初始化数据库操作队列）
    [DBManager reInitDBQueue];
    
    //获取当前用户文件目录（如没有则创建）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self DBPath];
    
    //判断数据库是否存在
    if (![fileManager fileExistsAtPath:dbPath])
    {
        [DBManager createTables];
    }
    else
    {
        //判断数据库版本是否变更; 如变更，删除数据库，重新建表
        NSString *sqliteVersion = [VersionOperations getDBVersion];
        if(![sqliteVersion isEqualToString:MY_SQLITE_VERSION])
        {
            [DBManager closeDB];
            
            NSError *error = nil;
            BOOL resultFlag =  [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
            
            if(!resultFlag)
            {
                //删除失败
            }
            else
            {
                [DBManager createTables];
            }
        }
    }
    return;
}

+ (void)createTables
{
    // To create your table
    
    //  创建版本管理表
    [self createTable:CREATE_VERSION_TABLE withTableName:T_DB_VERSION];
    [self createTable:CREATE_USER_TABLE withTableName:T_DB_USER];
    [self createTable:CREATE_AREA_TABLE withTableName:T_DB_AREA];
    [self createTable:CREATE_CART_TABLE withTableName:T_DB_CART];
    
    //设置数据库版本号
    [VersionOperations setDBVersion:MY_SQLITE_VERSION];
}


+ (void)createTable:(NSString*)sql withTableName:(NSString *)tableName
{
    FMDatabase * db = [FMDatabase databaseWithPath:[self DBPath]];
    if ([db open])
    {
        NSString *sSQL = [NSString stringWithFormat:sql,tableName];
        
        DDLogInfo(@"createTable SQL is:%@",sSQL);
        BOOL res = [db executeUpdate:sSQL];
        if (!res)
        {
            DDLogError(@"createTable SQL is:%@",sql);
        }
        else
        {
            DDLogInfo(@"succ to creating db table");
        }
        [db close];
    }
    else
    {
        DDLogError(@"db open failed");
    }
}

@end
