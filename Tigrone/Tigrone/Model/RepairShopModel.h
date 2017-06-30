//
//  RepairShopModel.h
//  Tigrone
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface RepairShopModel : NSObject

@property (nonatomic, strong)NSString *shopId;      //维修店ID
@property (nonatomic, strong)NSString *shopIcon;    //维修店图标url
@property (nonatomic, strong)NSString *shopName;    //名称
@property (nonatomic, strong)NSString *shopPhone;   //联系电话
@property (nonatomic, strong)NSString *shopCity;    //所在城市
@property (nonatomic, strong)NSString *shopCounty;  //所在区域
@property (nonatomic, strong)NSString *shopAddr;    //详细地址
@property (nonatomic, assign)CLLocationDegrees latitude;    //纬度
@property (nonatomic, assign)CLLocationDegrees longtitude;  //经度
@property (nonatomic, strong)NSString *businessTime;       //营业时间
@property (nonatomic, strong)NSString *totalScore;         //总体评分
@property (nonatomic, strong)NSString *serviceScore;      //服务评分
@property (nonatomic, strong)NSString *skillScore;        //技术评分
@property (nonatomic, strong)NSString *envirScore;        //环境评分
@property (nonatomic, strong)NSString *commentNum;        //评论条数
@property (nonatomic, strong)NSString *distanceStr;       //与当前位置相距距离
@property (nonatomic, strong)NSString *detailUrl;        //维修店详情

@end
