//
//  TigroneRequests.h
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"
#import "RepairShopModel.h"
#import "GoodsModel.h"
#import "UserInfoModel.h"
#import "CarModel.h"
#import "OrderModel.h"
#import "AddressModel.h"

@interface TigroneRequests : NSObject

//获取城市列表
+ (void)getCityListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取维修店列表
+ (void)getRepairShopList:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取维修店详情
+ (void)getShopDetailWithBlock:(void(^)(RepairShopModel *shopModel, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取车辆列表
+ (void)getCarListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取品牌列表
+ (void)getCarBrandsList:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic:(NSDictionary *)paramDic;

//获取车型
+ (void)getCarListByBrand:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *chinaArray,NSMutableArray *abroadArray,NSError *error))block paramDic:(NSDictionary *)paramDic;

//获取全部排量
+ (void)getVolumesByModelId:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic:(NSDictionary *)paramDic;

//获取年份
+ (void)getYearsByVolumeId:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic:(NSDictionary *)paramDic;

//获取商品列表
+ (void)getGoodsListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取商品详情
+ (void)getGoodsWithBlock:(void(^)(GoodsModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//根据排量获取商品详情
+ (void)getGoodsByVolumeIdWithBlock:(void (^)(GoodsModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;


//添加车辆
+ (void)addCarWithBlock:(void (^)(CarModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//更新车辆
+ (void)updateCarWithBlock:(void (^)(NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//切换车辆
+ (void)changeCarWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

//删除车辆
+ (void)deleteCarWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;


//用户获取当前车辆
+ (void)getCurrentCarWithBlock:(void(^)(CarModel *model, NSString *errorStr))block paramDic:(NSDictionary*)paramDic;

//反馈建议
+ (void)feedbackWithBlock:(void(^)(NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//修改昵称
+ (void)modifyNickNameWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic;

//修改邮箱
+ (void)modifyEmailWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic;

//修改手机号
+ (void)modifyPhoneWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic;

//获取用户信息
+ (void)getUserInformation:(void (^)(UserInfoModel *userModel, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//用户写评论

//获取维修店评论列表
+ (void)getShopCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取商品评论列表
+ (void)getGoodsCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//用户评论列表
+ (void)getUserCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//生成订单
+ (void)addTradeWithBlock:(void(^)(OrderModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//多个商品生成订单
+ (void)addNewTradeWithBlock:(void(^)(OrderModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//判断是否首单
+ (void)judgeIsFirstTradeWithBlock:(void(^)(BOOL isSuccess, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//获取优惠价格列表
+ (void)getDicountListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//订单列表
+ (void)getTradeListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//删除订单
+ (void)deleteTradeWithBlock:(void(^)(NSString *errorStr, BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//支付完成
+ (void)finishPayWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//退款
+ (void)refundWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//提交评论
+ (void)submitCommitWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//设置默认维修店
+ (void)setUserDefaultShopWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//获取首页轮播图
+ (void)getFirstImagesWithBlock:(void(^)(NSArray *resultArr,NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//修改用户头像
+ (void)setUserHeaderWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic fileData:(NSData *)imgData;

//获取地址列表
+ (void)getAddressListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic;

//添加地址
+ (void)addNewAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//修改地址
+ (void)editAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//设置常用地址
+ (void)setDefaultAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//获取常用地址
+ (void)getDefaultAddressWithBlock:(void(^)(NSString *errorStr,AddressModel *defaultModel))block paramDic:(NSDictionary *)paramDic;

//删除地址
+ (void)deleteAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//索要发票
+ (void)sendBillInfoWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

//确认收货
+ (void)confirmTradeWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic;

@end
