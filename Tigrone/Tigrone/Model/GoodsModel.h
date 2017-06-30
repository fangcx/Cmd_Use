//
//  GoodsModel.h
//  Tigrone
//
//  Created by Mac on 16/1/11.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, strong)NSString *goodsIcon;      //商品图片
@property (nonatomic ,strong)NSString *goodsId;         //商品Id
@property (nonatomic, strong)NSString *volumeId;        //排量Id
@property (nonatomic, strong)NSString *suitCarId;       //适用车辆Id
@property (nonatomic, strong)NSString *suitCar;         //适用的车辆
@property (nonatomic, strong)NSArray *goodsIconArr;      //商品大图
@property (nonatomic, strong)NSString *goodsName;       //商品名称
@property (nonatomic, strong)NSString *goodsDec;        //商品描述
@property (nonatomic, strong)NSString *originPrice;     //商品原价
@property (nonatomic ,strong)NSString *goodsPrice;      //商品价格
@property (nonatomic ,strong)NSString *commentNum;      //评论数目
@property (nonatomic ,strong)NSString *commentScore;    //商品评分

@property (nonatomic, strong)NSString *afterSales;      //售后服务
@property (nonatomic, strong)NSString *intr;            //商品介绍
@property (nonatomic, strong)NSString *packageList;     //包装清单
@property (nonatomic, strong)NSString *parameters;      //规格参数
@property (nonatomic, strong)NSString *offers;          //折扣
@property (nonatomic, strong)NSString *repertory;       //容量

@property (nonatomic, assign)NSUInteger maxValue;       //商品数目最大值


//用于购物车
@property (nonatomic, assign)NSUInteger goodsNum;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign)NSUInteger priceFirstDiscount; //首单减免额度

@end
