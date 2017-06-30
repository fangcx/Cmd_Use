//
//  CarModel.h
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject

@property (nonatomic, strong)NSString *carId;
@property (nonatomic, strong)NSString *carIcon; //图标url
@property (nonatomic, strong)UIImage  *carImg;  //图标
@property (nonatomic, strong)NSString *brandId;
@property (nonatomic, strong)NSString *brands;//品牌
@property (nonatomic, strong)NSString *modelsId;
@property (nonatomic, strong)NSString *models;//车型
@property (nonatomic, strong)NSString *volumeId;
@property (nonatomic, strong)NSString *volumes;//排量
@property (nonatomic, strong)NSString *yearId;
@property (nonatomic, strong)NSString *year;//生产年份
@property (nonatomic, strong)NSString *skuId;       //商品Id
@property (nonatomic, strong)NSString *allName;     //车子全名称
@property (nonatomic, strong)NSString *createDate;  //创建日期

@property (nonatomic, assign)BOOL isActive;

@end
