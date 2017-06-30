//
//  DBManager.h
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CoreUtils.h"

#define MY_SQLITE_VERSION    @"1.2"
#define MY_DB_NAME           @"TigroneDB.sqlite"
#define T_DB_VERSION         @"T_DB_VERSION"
#define T_DB_USER            @"T_DB_USER"

//城市
#define T_DB_AREA            @"T_DB_AREA"

//购物车
#define T_DB_CART            @"T_DB_CART"

@interface DBManager : NSObject

/**
 *  getDBQueue
 *
 *  @return FMDatabaseQueue object
 */
+ (FMDatabaseQueue *)getDBQueue;

/**
 *  重新初始化数据库，（更换用户后数据库路径会改变，需要重新初始化数据库操作队列）
 */
+(void)reInitDBQueue;

/**
 *  initDBSettings
 */
+ (void)initDBSettings;

/**
 *  close DB
 */
+ (void)closeDB;

/**
 *  DBPath
 *
 *  @return current db path
 */
+ (NSString *)DBPath;

@end
