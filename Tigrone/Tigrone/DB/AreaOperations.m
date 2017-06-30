//
//  AreaOperations.m
//  Tigrone
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "AreaOperations.h"
#import "FMDB.h"
#import "DBManager.h"
#import "NSString+Tigrone.h"

@implementation AreaOperations

//查询当前选中的城市
+ (AreaModel *)getCurrentCity
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block AreaModel *currentModel = [[AreaModel alloc] init];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@",T_DB_AREA];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             currentModel.areaId = [rs stringForColumn:@"areaId"];
             currentModel.areaName = [rs stringForColumn:@"areaName"];
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return currentModel;
}

//设置当前城市
+ (BOOL)setCurrentCity:(AreaModel *)model
{
    AreaModel *areaModel = [self getCurrentCity];
    if (![NSString isBlankString:areaModel.areaId]) {
        FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
        __block BOOL result = NO;
        
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET areaId = '%@',areaName = '%@' WHERE areaId = '%@'",T_DB_AREA,model.areaId,model.areaName,areaModel.areaId];
             
             result = [db executeUpdate:sql];
             
             if(!result)
             {
                 DDLogError(@"setData is Failed!!!");
             }
         }];
        return result;
    }
    else
    {
        FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
        __block BOOL result = NO;
        
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (areaId,areaName) VALUES ('%@','%@')",T_DB_AREA,model.areaId,model.areaName];
             
             result = [db executeUpdate:sql];
             
             if(!result)
             {
                 DDLogError(@"setData is Failed!!!");
             }
         }];
        return result;
    }
}

@end
