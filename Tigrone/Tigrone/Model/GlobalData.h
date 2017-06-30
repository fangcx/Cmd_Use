//
//  GlobalData.h
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>

@interface GlobalData : NSObject

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *phoneNum;

@property(nonatomic, strong)NSArray *repairShops;

@property(nonatomic, strong)NSArray *userInfos;
@property(nonatomic, strong)NSString *token;

@property(nonatomic, strong)BMKUserLocation *userLocation;
@property(nonatomic, assign)CLLocationCoordinate2D currentCoor;

@property(nonatomic, assign)BOOL isLogin;       //是否已经登录

+(GlobalData*)shareInstance;

@end
