//
//  OrderModel.h
//  Tigrone
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property(nonatomic, strong) NSString *partner;            //合作伙伴Id
@property(nonatomic, strong) NSString *seller;             //商家账号
@property(nonatomic, strong) NSString *tradeNO;            //订单号
@property(nonatomic, strong) NSString *shopId;              //维修店Id
@property(nonatomic, strong) NSString *shopName;            //维修店名称
@property(nonatomic, strong) NSString *skuId;               //商品Id
@property(nonatomic, strong) NSString *skuName;             //商品名称
@property(nonatomic, strong) NSString *userCarId;           //车辆Id
@property(nonatomic, strong) NSString *userCarName;         //车辆名称
@property(nonatomic, strong) NSString *userId;              //用户Id

//0是待发货，1是已发货，2是已收货,3是退货，4退货已入库
@property(nonatomic, assign) NSUInteger wuliuStatus;        //物流状态


@property(nonatomic, strong) NSString *priceStr;            //商品价格
@property(nonatomic, strong) NSString *reDate;              //时间
@property(nonatomic, strong) NSString *iconUrl;             //图标url

@property(nonatomic, strong) NSArray *goodsArr;             //商品数组
@property(nonatomic,strong) NSString *wuliuName;            //收货人姓名
@property(nonatomic,strong) NSString *wuliuPhone;           //收货人联系电话
@property(nonatomic,strong) NSString *addressId;            //收货人地址id
@property(nonatomic,strong) NSString *detailAddr;           //收货人详细地址
@property(nonatomic,strong) NSString *province;             //收货人所在省
@property(nonatomic,strong) NSString *city;                 //收货人所在市区

//0:未完成 2:取消 3：完成
@property(nonatomic, assign) NSUInteger orderStatus;        //订单状态

//0是未索要，1是已索要，2已开出，等待收件，3以发货，4已收到，-1异常
@property (nonatomic, assign)NSUInteger invoiceStatus;  //发票状态

@property (nonatomic, strong)NSString *goodWuliusn;     //商品物流单号
@property (nonatomic, strong)NSString *billWulius;      //发票的物流单号


/**0未支付，
 1已经支付 ，显示退款入口
 2,退款中，请等待处理
 3,已退款完成
 **/
@property(nonatomic, assign) NSUInteger payStatus;          //支付状态
@property(nonatomic, strong) NSString *shopAddr;            //维修店地址

@property(nonatomic, strong) NSString *notifyURL;           //回调url
@property(nonatomic, strong) NSString *service;
@property(nonatomic, strong) NSString *paymentType;
@property(nonatomic, strong) NSString *inputCharset;
@property(nonatomic, strong) NSString *itBPay;
@property(nonatomic, strong) NSString *showUrl;
@property(nonatomic, strong) NSString *returnUrl;

@property(nonatomic, strong) NSMutableDictionary * extraParams;

@end
