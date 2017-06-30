//
//  CartOperations.h
//  Tigrone
//
//  Created by Mac on 16/6/28.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface CartOperations : NSObject

//获取购物车里所有商品
+ (NSMutableArray *)selectAllGoodsOfCart;

//添加商品到购物车
+ (BOOL)insertGoodsToCart:(GoodsModel *)model;

//添加商品数量
+ (BOOL)addGoodsNumOfCart:(GoodsModel *)model;

//减少商品数量
+ (BOOL)minusGoodsNUmOfCart:(GoodsModel *)model;

//删除商品
+ (BOOL)deleteGoodsOfCart:(GoodsModel *)model;

//获取商品数目
+ (NSUInteger)selectGoodsNum:(GoodsModel *)model;

@end
