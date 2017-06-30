//
//  CartOperations.m
//  Tigrone
//
//  Created by Mac on 16/6/28.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "CartOperations.h"
#import "FMDB.h"
#import "DBManager.h"
#import "NSString+Tigrone.h"
#import "CommonMacro.h"
#import "GlobalData.h"

@implementation CartOperations

//获取购物车里所有商品
+ (NSMutableArray *)selectAllGoodsOfCart
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userName = '%@'",T_DB_CART,PhoneNum];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             GoodsModel *model = [[GoodsModel alloc] init];
             model.goodsId = [rs stringForColumn:@"cartId"];
             model.goodsIcon = [rs stringForColumn:@"goodsIcon"];
             model.goodsName = [rs stringForColumn:@"goodsName"];
             model.goodsDec = [rs stringForColumn:@"goodsDec"];
             model.goodsPrice = [rs stringForColumn:@"goodsPrice"];
             model.goodsNum = [rs intForColumn:@"goodsNum"];
             model.suitCar = [rs stringForColumn:@"suitCar"];
             model.priceFirstDiscount = [rs intForColumn:@"priceFirstDiscount"];
             model.maxValue = [rs intForColumn:@"maxValue"];
             
             [resultArray addObject:model];
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return resultArray;
}

//添加商品到购物车
+ (BOOL)insertGoodsToCart:(GoodsModel *)model
{
    model.goodsDec = @"前刹(一盒4片装)";
    if (![self queryGoodsIsAlreadyExist:model.goodsId])
    {
        FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
        __block BOOL result = NO;
        
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (cartId,goodsIcon,goodsName,goodsDec,goodsPrice,goodsNum,userName,suitCar,priceFirstDiscount,maxValue) VALUES('%@','%@','%@','%@','%@','%ld','%@','%@','%ld','%ld')",T_DB_CART,model.goodsId,model.goodsIcon,model.goodsName,model.goodsDec,model.goodsPrice,model.goodsNum,PhoneNum,model.suitCar,model.priceFirstDiscount,model.maxValue];
             result = [db executeUpdate:sql];
             
             if(!result)
             {
                 DDLogError(@"insert Goods is Failed!!!");
             }
         }];
        
        return result;
    }else
    {
        //增加商品的数量
        return [self addGoodsNumOfCart:model];
    }
}


//添加商品数量
+ (BOOL)addGoodsNumOfCart:(GoodsModel *)model
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET goodsNum = goodsNum+1 where cartId = '%@' and userName = '%@'",T_DB_CART,model.goodsId,PhoneNum];
         
         result = [db executeUpdate:sql];
     }];
    return result;
}

//减少商品数量
+ (BOOL)minusGoodsNUmOfCart:(GoodsModel *)model
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET goodsNum = goodsNum-1 where cartId = '%@' and userName = '%@'",T_DB_CART,model.goodsId,PhoneNum];
         
         result = [db executeUpdate:sql];
     }];
    return result;
}

//删除商品
+ (BOOL)deleteGoodsOfCart:(GoodsModel *)model
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE cartId='%@' and userName='%@' ",T_DB_CART,model.goodsId,PhoneNum];
         
         result = [db executeUpdate:sql];
     }];
    
    return result;
}

//获取商品数目
+ (NSUInteger)selectGoodsNum:(GoodsModel *)model
{
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    __block NSUInteger goodsNum = 0;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userName = '%@' and cartId = '%@'",T_DB_CART,PhoneNum,model.goodsId];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
           goodsNum = [rs intForColumn:@"goodsNum"];
             
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return goodsNum;
}

+(BOOL)queryGoodsIsAlreadyExist:(NSString *)goodsId
{
    __block  BOOL isAlreadyExist = NO;
    
    FMDatabaseQueue *dataQueue = [DBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userName = '%@' and cartId = '%@'",T_DB_CART,PhoneNum,goodsId];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             isAlreadyExist = YES;
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return isAlreadyExist;
}

@end
