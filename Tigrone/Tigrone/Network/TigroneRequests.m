//
//  TigroneRequests.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//


#import "TigroneRequests.h"
#import "AppNetAPIClient.h"
#import "CoreUtils.h"
#import "CommonMacro.h"
#import "NSString+Tigrone.h"
#import "GlobalData.h"
#import "BrandsModel.h"
#import "ModelsModel.h"
#import "VolumesModel.h"
#import "YearModel.h"
#import "ShopCommentModel.h"
#import "GoodsCommentModel.h"
#import "MyCommentModel.h"
#import "ImageModel.h"

@implementation TigroneRequests

//获取城市列表
+ (void)getCityListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"citys";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取城市失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *cityArr = [responseObject objectForKey:@"citys"];
         if (cityArr && cityArr.count > 0) {
             for (NSDictionary *item in cityArr) {
                 AreaModel *model = [[AreaModel alloc] init];
                 model.areaId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.areaName = [item objectForKey:@"name"];
                 [resultArr addObject:model];
             }
         }
         
         if (block) {
             block(resultArr,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取城市失败");
         }
     }];
}

+ (void)getRepairShopList:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"city/shop";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取维修店失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *cityArr = [responseObject objectForKey:@"shops"];
         if (cityArr && cityArr.count > 0) {
             for (NSDictionary *item in cityArr) {
                 RepairShopModel *model = [[RepairShopModel alloc] init];
                 model.shopId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.shopIcon = [item objectForKey:@"icon"];
                 model.shopName = [item objectForKey:@"name"];
                 model.shopPhone = [item objectForKey:@"phone"];
                 model.shopCity = [item objectForKey:@"city"];
                 if (item[@"county"]) {
                     model.shopCounty = [item objectForKey:@"county"];
                 }
                 model.shopAddr = [item objectForKey:@"address"];
                 model.commentNum = [NSString stringWithFormat:@"%@",[item objectForKey:@"commentNum"]];
                 if (item[@"contextUrl"]) {
                     model.detailUrl = item[@"contextUrl"];
                 }
                 NSString *coorStr = [item objectForKey:@"lbs"];
                 if (![NSString isBlankString:coorStr]) {
                     NSArray *array = [coorStr componentsSeparatedByString:@","];
                     if (array.count > 0) {
                         model.longtitude = [array[0] doubleValue];
                         
//                         //test
//                         model.latitude = 31.41 + arc4random()/0x100000000;
                     }
                     
                     if (array.count > 1) {
                         model.latitude = [array[1] doubleValue];
                         
//                         //test
//                         model.longtitude = 121.48;
                     }
                 }
                 
                 model.businessTime = [item objectForKey:@"businessTime"];
                 model.totalScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score"]];
                 model.serviceScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score1"]];
                 model.skillScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score2"]];
                 model.envirScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score3"]];
                 
                 [resultArr addObject:model];
             }
         }
         
         [GlobalData shareInstance].repairShops = resultArr;
         
         if (block) {
             block(resultArr,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取维修店失败");
         }
     }];
}

//获取维修店详情
+ (void)getShopDetailWithBlock:(void(^)(RepairShopModel *shopModel, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"shop";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取维修店详情失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSDictionary *item = [responseObject objectForKey:@"shop"];
         RepairShopModel *model = [[RepairShopModel alloc] init];
         model.shopId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
         model.shopIcon = [item objectForKey:@"icon"];
         model.shopName = [item objectForKey:@"name"];
         model.shopPhone = [item objectForKey:@"phone"];
         model.shopCity = [item objectForKey:@"city"];
         if (item[@"county"]) {
             model.shopCounty = [item objectForKey:@"county"];
         }
         model.shopAddr = [item objectForKey:@"address"];
         model.commentNum = [NSString stringWithFormat:@"%@",[item objectForKey:@"commentNum"]];
         if (item[@"contextUrl"]) {
             model.detailUrl = item[@"contextUrl"];
         }
         
         NSString *coorStr = [item objectForKey:@"lbs"];
         if (![NSString isBlankString:coorStr]) {
             NSArray *array = [coorStr componentsSeparatedByString:@","];
             if (array.count > 0) {
                 model.longtitude = [array[0] doubleValue];
            }
             
             if (array.count > 1) {
                 model.latitude = [array[1] doubleValue];
             }
         }
         
         model.businessTime = [item objectForKey:@"businessTime"];
         model.totalScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score"]];
         model.serviceScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score1"]];
         model.skillScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score2"]];
         model.envirScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score3"]];
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取维修店详情失败");
         }
     }];
}

//获取车辆列表
+ (void)getCarListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/getCars";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取车辆列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *carArr = [responseObject objectForKey:@"cars"];
         if (carArr && carArr.count > 0) {
             for (NSDictionary *item in carArr) {
                 CarModel *model = [[CarModel alloc] init];
                 model.carId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.brandId = [NSString stringWithFormat:@"%@",[item objectForKey:@"brandId"]];
                model.modelsId = [NSString stringWithFormat:@"%@",[item objectForKey:@"modelsId"]];
                 model.volumeId = [NSString stringWithFormat:@"%@",[item objectForKey:@"volumeId"]];
                 model.yearId = [NSString stringWithFormat:@"%@",[item objectForKey:@"yearId"]];
                 model.skuId = [NSString stringWithFormat:@"%@",[item objectForKey:@"skuId"]];
                 
                 NSString *activeStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"is_active"]];
                 model.isActive = [activeStr boolValue];
                 
                 model.carIcon = [item objectForKey:@"icon"];
                 model.allName = [item objectForKey:@"allName"];
                 
                 NSString *createDateStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"createdDate"]];
                 
                 model.createDate = [NSString convertMsToTimeString:createDateStr];
                 
                 [resultArr addObject:model];
             }
         }
                  
         if (block) {
             block(resultArr,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取车辆列表失败");
         }
     }];
}

//获取商品详情
+ (void)getGoodsWithBlock:(void(^)(GoodsModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"sku";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取商品失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         GoodsModel *model = [[GoodsModel alloc] init];
         
         NSDictionary *dataDic = [responseObject objectForKey:@"sku"];
         if (dataDic) {
             model.goodsId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"id"]];
             model.goodsName = [dataDic objectForKey:@"title"];
             model.originPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"priceOld"]];
             model.goodsPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"price"]];
             model.commentNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentNum"]];
             model.commentScore = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"score"]];
             
             model.afterSales = [dataDic objectForKey:@"afterSales"];
             model.intr = [dataDic objectForKey:@"intr"];
             model.packageList = [dataDic objectForKey:@"packageList"];
             model.parameters = [dataDic objectForKey:@"parameters"];
             model.offers = [dataDic objectForKey:@"offers"];
             model.repertory = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"repertory"]];
             model.suitCar = [dataDic objectForKey:@"allName"];
             model.volumeId = [NSString stringWithoutNil:[dataDic objectForKey:@"volumeId"]];
             model.maxValue = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"maxValue"]] integerValue];
             
             NSString *priceFirstDiscount = [NSString stringWithFormat:@"%@",dataDic[@"priceFirstDiscount"]];
             if (![NSString isBlankString:priceFirstDiscount]) {
                 model.priceFirstDiscount = [priceFirstDiscount integerValue];
             }
             
             //大图
             NSString *iconUrls = [dataDic objectForKey:@"icon"];
             if (![NSString isBlankString:iconUrls]) {
                 model.goodsIconArr = [iconUrls componentsSeparatedByString:@","];
             }
             
             if (model.goodsIconArr.count > 0) {
                 model.goodsIcon = model.goodsIconArr[0];
             }
         }
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取商品失败");
         }
     }];
}

//根据排量获取商品详情
+ (void)getGoodsByVolumeIdWithBlock:(void (^)(GoodsModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"car/skuByVolumeId";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取商品失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         GoodsModel *model = [[GoodsModel alloc] init];
         
         NSDictionary *dataDic = [responseObject objectForKey:@"sku"];
         if (dataDic) {
             model.goodsId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"id"]];
             model.goodsName = [dataDic objectForKey:@"title"];
             model.originPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"priceOld"]];
             model.goodsPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"price"]];
             model.commentNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentNum"]];
             model.commentScore = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"score"]];
             
             model.afterSales = [dataDic objectForKey:@"afterSales"];
             model.intr = [dataDic objectForKey:@"intr"];
             model.packageList = [dataDic objectForKey:@"packageList"];
             model.parameters = [dataDic objectForKey:@"parameters"];
             model.offers = [dataDic objectForKey:@"offers"];
             model.repertory = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"repertory"]];
             model.suitCar = [dataDic objectForKey:@"allName"];
             model.volumeId = [NSString stringWithoutNil:[dataDic objectForKey:@"volumeId"]];
             
             NSString *priceFirstDiscount = [NSString stringWithFormat:@"%@",dataDic[@"priceFirstDiscount"]];
             if (![NSString isBlankString:priceFirstDiscount]) {
                 model.priceFirstDiscount = [priceFirstDiscount integerValue];
             }
             
             //大图
             NSString *iconUrls = [dataDic objectForKey:@"icon"];
             if (![NSString isBlankString:iconUrls]) {
                 model.goodsIconArr = [iconUrls componentsSeparatedByString:@","];
             }
         }
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取商品失败");
         }
     }];
}

//获取品牌列表
+ (void)getCarBrandsList:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic: (NSDictionary *)paramDic
{
    NSString *urlString = @"car/brands";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
    {
        NSString *retCode = responseObject[@"resultCode"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc]init];
            
            NSArray *brandsArray = responseObject[@"brands"];
            
            for (NSDictionary *dic in brandsArray)
            {
                BrandsModel *model = [[BrandsModel alloc]init];
                model._id = [NSString stringWithoutNil:[dic objectForKey:@"id"]];
                model.name = [NSString stringWithoutNil:[dic objectForKey:@"name"]];
                model.icon = [NSString stringWithoutNil:[dic objectForKey:@"icon"]];
                [returnArray addObject:model];
            }
            if (block)
            {
                block(retCode,@"获取列表成功",returnArray,nil);
            }
        }
        else
        {
            if (block)
            {
                block(retCode,@"获取列表失败",[NSMutableArray array],nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (block)
        {
            block(nil,@"获取列表失败",nil,error);
        }
    }
     ];
}

//获取车型
+ (void)getCarListByBrand:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *chinaArray,NSMutableArray *abroadArray,NSError *error))block paramDic: (NSDictionary *)paramDic
{
    NSString *urlString = @"car/modelsByBrandId";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
    {
        NSString *retCode = responseObject[@"resultCode"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSMutableArray *chinaArr = [[NSMutableArray alloc]init];
            NSMutableArray *abroadArr = [[NSMutableArray alloc]init];
            
            NSArray *brandsArray = responseObject[@"models"];
            
            for (NSDictionary *dic in brandsArray)
            {
                ModelsModel *model = [[ModelsModel alloc]init];
                model._id = [NSString stringWithoutNil:[dic objectForKey:@"id"]];
                model.name = [NSString stringWithoutNil:[dic objectForKey:@"name"]];
                
                NSString *isImportStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isImport"]];
                model.isChina = ![isImportStr boolValue];
                
                if (model.isChina) {
                    [chinaArr addObject:model];
                }
                else
                {
                    [abroadArr addObject:model];
                }
                
            }
            if (block)
            {
                block(retCode,@"获取列表成功",chinaArr,abroadArr,nil);
            }
        }
        else
        {
            if (block)
            {
                block(retCode,@"获取列表失败",nil,nil,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (block)
        {
            block(nil,@"获取列表失败",nil,nil,error);
        }
    }];
}

//获取全部排量
//
+ (void)getVolumesByModelId:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"car/volumesByModelId";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
    {
        NSString *retCode = responseObject[@"resultCode"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc]init];
            
            NSMutableArray *brandsArray = responseObject[@"volumes"];
            
            for (NSDictionary *dic in brandsArray)
            {
                VolumesModel *model = [[VolumesModel alloc]init];
                model._id = [NSString stringWithoutNil:[dic objectForKey:@"id"]];
                model.name = [NSString stringWithoutNil:[dic objectForKey:@"name"]];
                [returnArray addObject:model];
            }
            if (block)
            {
                block(retCode,@"获取列表成功",returnArray,nil);
            }
        }
        else
        {
            if (block)
            {
                block(retCode,@"获取列表失败",[NSMutableArray array],nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (block)
        {
            block(nil,@"获取列表失败",nil,error);
        }
    }];
}

//获取年份
+ (void)getYearsByVolumeId:(void(^)(NSString *retcode,NSString *retmessage,NSMutableArray *resultArray,NSError *error))block paramDic: (NSDictionary *)paramDic
{
    NSString *urlString = @"car/yearsByVolumeId";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
    {
         NSString *retCode = responseObject[@"resultCode"];
        
         if ([retCode isEqualToString:kSuccessCode])
         {
             NSMutableArray *returnArray = [[NSMutableArray alloc]init];
             
             NSMutableArray *brandsArray = responseObject[@"years"];
             
             for (NSDictionary *dic in brandsArray)
             {
                 YearModel *model = [[YearModel alloc]init];
                 model._id = [NSString stringWithoutNil:[dic objectForKey:@"id"]];
                 model.name = [NSString stringWithoutNil:[dic objectForKey:@"name"]];
                 [returnArray addObject:model];
             }
             
             if (block)
             {
                 block(retCode,@"获取列表成功",returnArray,nil);
             }
         }
         else
         {
             if (block)
             {
                 block(retCode,@"获取列表失败",[NSMutableArray array],nil);
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (block)
         {
             block(nil,@"获取列表失败",nil,error);
         }
     }];
}

//获取用户信息
+ (void)getUserInformation:(void (^)(UserInfoModel *userModel, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [responseObject objectForKey:kResultCode];
        
        if (![resultCode isEqualToString:kSuccessCode]) {
            NSString *errorStr = @"获取用户信息失败";
            
            if ([responseObject objectForKey:kResultMsg]) {
                if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                    errorStr = [responseObject objectForKey:kResultMsg];
                }
            }
            if (block) {
                block(nil, errorStr);
            }
            return;
        }
        
        UserInfoModel *userModel = [[UserInfoModel alloc] init];
        NSDictionary *userDict = [responseObject objectForKey:@"user"];
        
        if (userDict) {
            
            userModel.userId = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            if ([userDict objectForKey:@"name"]) {
                userModel.userName = [userDict objectForKey:@"name"];
            }
            userModel.userPhone = [userDict objectForKey:@"phone"];
            
            if ([userDict objectForKey:@"email"]) {
                userModel.userEmail = [userDict objectForKey:@"email"];
            }
            
            if (userDict[@"shopId"]) {
                userModel.shopId = [NSString stringWithFormat:@"%@",userDict[@"shopId"]];
            }
            
            if (userDict[@"shopName"]) {
                userModel.shopName = userDict[@"shopName"];
            }
            
            if (userDict[@"shopAddress"]) {
                userModel.shopAddr = userDict[@"shopAddress"];
            }
            
            if (userDict[@"icon"]) {
                userModel.userIcon = userDict[@"icon"];
            }
        }
        
        if (block) {
            block(userModel, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,@"获取用户信息失败");
        }
    }];
}

//添加车辆
+ (void)addCarWithBlock:(void (^)(CarModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/addCar";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [responseObject objectForKey:kResultCode];
        
        if (![resultCode isEqualToString:kSuccessCode]) {
            NSString *errorStr = @"用户添加车辆失败";
            
            if ([responseObject objectForKey:kResultMsg]) {
                if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                    errorStr = [responseObject objectForKey:kResultMsg];
                }
            }
            if (block) {
                block(nil,errorStr);
            }
            return;
        }
        
        
        //请求成功
        CarModel *model = [[CarModel alloc] init];
        
        NSDictionary *item = [responseObject objectForKey:@"car"];
        
        model.carId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
        model.brandId = [NSString stringWithFormat:@"%@",[item objectForKey:@"brandId"]];
        model.modelsId = [NSString stringWithFormat:@"%@",[item objectForKey:@"modelsId"]];
        model.volumeId = [NSString stringWithFormat:@"%@",[item objectForKey:@"volumeId"]];
        model.yearId = [NSString stringWithFormat:@"%@",[item objectForKey:@"yearId"]];
        model.skuId = [NSString stringWithFormat:@"%@",[item objectForKey:@"skuId"]];
        
        NSString *activeStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"is_active"]];
        model.isActive = [activeStr boolValue];
        
        model.carIcon = [item objectForKey:@"icon"];
        model.allName = [item objectForKey:@"allName"];
        
        NSString *createDateStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"createdDate"]];
        
        model.createDate = [NSString convertMsToTimeString:createDateStr];
        
        if (block) {
            block(model,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,@"用户添加车辆失败");
        }
    }];
}

//更新车辆
+ (void)updateCarWithBlock:(void (^)(NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/editCar";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [responseObject objectForKey:kResultCode];
        
        if (![resultCode isEqualToString:kSuccessCode]) {
            NSString *errorStr = @"用户更新车辆失败";
            
            if ([responseObject objectForKey:kResultMsg]) {
                if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                    errorStr = [responseObject objectForKey:kResultMsg];
                }
            }
            if (block) {
                block(errorStr);
            }
            return;
        }
        
        
        //success
        if (block) {
            block(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(@"用户更新车辆失败");
        }
    }];
}

//切换车辆
+ (void)changeCarWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/changeCar";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if (block){
            block(retCode,resultMsg,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"切换车辆失败",error);
        }
    }];
}

//删除车辆
+ (void)deleteCarWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/delCar";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if (block){
            block(retCode,resultMsg,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"删除车辆失败",error);
        }
    }];
}

//用户获取当前车辆
+ (void)getCurrentCarWithBlock:(void(^)(CarModel *model, NSString *errorStr))block paramDic:(NSDictionary*)paramDic
{
    NSString *urlString = @"user/activeCar";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取当前车辆失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         CarModel *model = [[CarModel alloc] init];
         
         NSDictionary *item = [responseObject objectForKey:@"car"];
         
         model.carId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
         model.brandId = [NSString stringWithFormat:@"%@",[item objectForKey:@"brandId"]];
         model.modelsId = [NSString stringWithFormat:@"%@",[item objectForKey:@"modelsId"]];
         model.volumeId = [NSString stringWithFormat:@"%@",[item objectForKey:@"volumeId"]];
         model.yearId = [NSString stringWithFormat:@"%@",[item objectForKey:@"yearId"]];
         model.skuId = [NSString stringWithFormat:@"%@",[item objectForKey:@"skuId"]];
         
         NSString *activeStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"is_active"]];
         model.isActive = [activeStr boolValue];
         
         model.carIcon = [item objectForKey:@"icon"];
         model.allName = [item objectForKey:@"allName"];
         
         NSString *createDateStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"createdDate"]];
         
         model.createDate = [NSString convertMsToTimeString:createDateStr];
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取当前车辆失败");
         }
     }];
}

//反馈建议
+ (void)feedbackWithBlock:(void(^)(NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"tellme/add";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"提交反馈失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"提交反馈失败");
         }
     }];
}

//修改昵称
+ (void)modifyNickNameWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/changeName";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"昵称修改失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"昵称修改失败");
         }
     }];
}

//修改邮箱
+ (void)modifyEmailWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/changeEmail";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"邮箱修改失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"邮箱修改失败");
         }
     }];
}

//修改手机号
+ (void)modifyPhoneWithBlock:(void(^)(NSString *errorStr))block parmaDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/changePhone";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"手机号修改失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"手机号修改失败");
         }
     }];
}

//获取维修店评论列表
+ (void)getShopCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"shop/comments";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取评论列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *commentArr = [responseObject objectForKey:@"comments"];
         if (commentArr && commentArr.count > 0) {
             for (NSDictionary *item in commentArr) {
                 ShopCommentModel *model = [[ShopCommentModel alloc] init];
                 model.commentId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.shopId = [NSString stringWithFormat:@"%@",[item objectForKey:@"shopId"]];
                 model.commentContent = [item objectForKey:@"contextShop"];
                 model.userName = [item objectForKey:@"userName"];
                 model.userIcon = [item objectForKey:@"userIcon"];
                 model.userName = [item objectForKey:@"userName"];
                 model.commentTitle = [item objectForKey:@"title"];
                 model.commentScore = [item objectForKey:@"scoreShop"];
                 model.serverScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score1"]];
                 model.skillScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score2"]];
                 model.enviScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score3"]];
                 [resultArray addObject:model];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取评论列表失败");
         }
     }];
}

//获取商品评论列表
+ (void)getGoodsCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"sku/comments";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取评论列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *commentArr = [responseObject objectForKey:@"comments"];
         if (commentArr && commentArr.count > 0) {
             for (NSDictionary *item in commentArr) {
                 GoodsCommentModel *model = [[GoodsCommentModel alloc] init];
                 model.commentId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.skuId = [NSString stringWithFormat:@"%@",[item objectForKey:@"skuId"]];
                 model.commentContent = [item objectForKey:@"contextSku"];
                 model.commentName = [item objectForKey:@"userName"];
                 model.commentScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score"]];
                 [resultArray addObject:model];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取评论列表失败");
         }
     }];
}

//用户评论列表
+ (void)getUserCommentListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/comments";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取评论列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *commentArr = [responseObject objectForKey:@"comments"];
         if (commentArr && commentArr.count > 0) {
             for (NSDictionary *item in commentArr) {
                 MyCommentModel *model = [[MyCommentModel alloc] init];
                 model.commentId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.shopIcon = [item objectForKey:@"userIcon"];
                 model.commentContent = [item objectForKey:@"contextShop"];
                 model.commentName = [item objectForKey:@"userName"];
                 model.commentScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"scoreShop"]];
                 [resultArray addObject:model];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取评论列表失败");
         }
     }];
}

//生成订单
+ (void)addTradeWithBlock:(void(^)(OrderModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/add2";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"生成订单失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSDictionary *tradeDic = [responseObject objectForKey:@"trade"];
         OrderModel *model = [[OrderModel alloc] init];
         model.tradeNO = [NSString stringWithFormat:@"%@",tradeDic[@"id"]];
         model.shopId = [NSString stringWithFormat:@"%@",tradeDic[@"shopId"]];
         model.skuId = [NSString stringWithFormat:@"%@",tradeDic[@"skuId"]];
         model.userCarId = [NSString stringWithFormat:@"%@",tradeDic[@"userCarId"]];
         model.userId = [NSString stringWithFormat:@"%@",tradeDic[@"userId"]];
         model.shopName = tradeDic[@"shopName"];
         model.skuName = tradeDic[@"skuName"];
         model.userCarName = tradeDic[@"userCarName"];
         model.priceStr = [NSString stringWithFormat:@"%@",tradeDic[@"amount"]];
         model.reDate = [NSString convertMsToDateString:[NSString stringWithFormat:@"%@",tradeDic[@"lastDate"]]];
         model.orderStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"dstatus"]] integerValue];
         model.payStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"payStatus"]] integerValue];
         model.iconUrl = tradeDic[@"iconUrl"];
         
         if (tradeDic[@"address"]) {
             model.shopAddr = tradeDic[@"address"];
         }
         
         NSMutableDictionary *extraDic = [[NSMutableDictionary alloc] init];
         
         if (model.shopId) {
             [extraDic setObject:model.shopId forKey:@"shopId"];
         }
         if (model.shopName) {
             [extraDic setObject:model.shopName forKey:@"shopName"];
         }
         if (model.skuId) {
             [extraDic setObject:model.skuId forKey:@"skuId"];
         }
         if (model.skuName) {
             [extraDic setObject:model.skuName forKey:@"skuName"];
         }
         if (model.userCarId) {
             [extraDic setObject:model.userCarId forKey:@"userCarId"];
         }
         if (model.userCarName) {
             [extraDic setObject:model.userCarName forKey:@"userCarName"];
         }
         if (model.reDate) {
             [extraDic setObject:model.reDate forKey:@"lastDate"];
         }
         
         model.extraParams = extraDic;
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"生成订单失败");
         }
     }];
}

//判断是否首单
+ (void)judgeIsFirstTradeWithBlock:(void(^)(BOOL isSuccess, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/priceFirstDiscount";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"不是首单";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(NO,errorStr);
             }
             return;
         }
         
         //请求成功
         if (block) {
             NSString *firstMsg = [responseObject objectForKey:@"message"];
             if (firstMsg && [firstMsg isEqualToString:@"first"]) {
                 block(YES,nil);
             }
             else
             {
                 block(NO,nil);
             }
             
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(NO,@"不是首单");
         }
     }];
}

//获取优惠价格列表
+ (void)getDicountListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"discount";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取评论列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *vosArr = [responseObject objectForKey:@"discountVos"];
         if (vosArr && vosArr.count > 0) {
             for (NSDictionary *item in vosArr) {
                 [resultArray addObject:item];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取评论列表失败");
         }
     }];
}

//订单列表
+ (void)getTradeListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/all";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取订单列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *tradeArr = [responseObject objectForKey:@"trades"];
         if (tradeArr && tradeArr.count > 0) {
             for (NSDictionary *item in tradeArr) {
                 OrderModel *model = [[OrderModel alloc] init];
                 model.tradeNO = [NSString stringWithFormat:@"%@",item[@"id"]];
                 model.shopId = [NSString stringWithFormat:@"%@",item[@"shopId"]];
                 model.skuId = [NSString stringWithFormat:@"%@",item[@"skuId"]];
                 model.userCarId = [NSString stringWithFormat:@"%@",item[@"userCarId"]];
                 model.userId = [NSString stringWithFormat:@"%@",item[@"userId"]];
                 model.shopName = item[@"shopName"];
                 model.skuName = item[@"skuName"];
                 model.userCarName = item[@"userCarName"];
                 model.priceStr = [NSString stringWithFormat:@"%@",item[@"amount"]];
                 model.reDate = [NSString convertMsToDateString:[NSString stringWithFormat:@"%@",item[@"lastDate"]]];
                 model.shopAddr = item[@"address"];
                 
                 model.orderStatus = [[NSString stringWithFormat:@"%@",item[@"dstatus"]] integerValue];
                 
                 model.payStatus = [[NSString stringWithFormat:@"%@",item[@"payStatus"]] integerValue];
                 
                 model.wuliuStatus = [[NSString stringWithFormat:@"%@",item[@"wuliuStatus"]] integerValue];
                 
                 if (item[@"wuliuSN"]) {
                     model.goodWuliusn = [NSString stringWithFormat:@"%@",item[@"wuliuSN"]];
                 }
                 
                 if (item[@"invoiceSN"]) {
                     model.billWulius = [NSString stringWithFormat:@"%@",item[@"invoiceSN"]];
                 }
                 
                 model.iconUrl = item[@"iconUrl"];
                 
                 //skus
                 NSString *tmpSkuStr = item[@"skus"];
                 NSData* aData= [tmpSkuStr dataUsingEncoding: NSUTF8StringEncoding];
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:nil];
                 
                 NSArray *tmpSkuArr = (NSArray *)jsonObject;
                 if (tmpSkuArr > 0) {
                     NSMutableArray *skuArr = [[NSMutableArray alloc] init];
                     for (NSDictionary *tmpItem in tmpSkuArr) {
                         GoodsModel *model = [[GoodsModel alloc] init];
                         
                         //大图
                         NSString *iconUrls = [tmpItem objectForKey:@"icon"];
                         if (![NSString isBlankString:iconUrls]) {
                             model.goodsIconArr = [iconUrls componentsSeparatedByString:@","];
                         }
                         
                         if (model.goodsIconArr.count > 0) {
                             model.goodsIcon = model.goodsIconArr[0];
                         }
                         model.goodsId = [NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"skuId"]];
                         
                         model.goodsNum = [[NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"num"]] integerValue];
                         
                         model.goodsName = [tmpItem objectForKey:@"skuName"];
                         
                         model.goodsPrice = [NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"price"]];
                         
                         [skuArr addObject:model];
                     }
                     model.goodsArr = [skuArr copy];
                 }
                 
                 model.invoiceStatus = [[NSString stringWithFormat:@"%@",item[@"invoiceStatus"]] integerValue];
                 model.wuliuName = item[@"wuliuName"];
                 model.wuliuPhone = item[@"wuliuPhone"];
                 model.addressId = [NSString stringWithFormat:@"%@",item[@"addressId"]];
                 model.detailAddr = item[@"address"];
                 model.province = item[@"province"];
                 model.city = item[@"city"];
                 
                 NSMutableDictionary *extraDic = [[NSMutableDictionary alloc] init];
                 
                
                 if (model.goodsArr.count > 0) {
                     [extraDic setObject:model.goodsArr forKey:@"skus"];
                 }
                 if (model.wuliuName) {
                     [extraDic setObject:model.skuId forKey:@"wuliuName"];
                 }
                 if (model.wuliuPhone) {
                     [extraDic setObject:model.skuId forKey:@"wuliuPhone"];
                 }
                 if (model.addressId) {
                     [extraDic setObject:model.skuId forKey:@"addressId"];
                 }
                 if (model.detailAddr) {
                     [extraDic setObject:model.skuId forKey:@"address"];
                 }
                 if (model.province) {
                     [extraDic setObject:model.skuId forKey:@"province"];
                 }
                 if (model.city) {
                     [extraDic setObject:model.skuId forKey:@"city"];
                 }
                 if (model.skuId) {
                     [extraDic setObject:model.skuId forKey:@"skuId"];
                 }
                 if (model.skuName) {
                     [extraDic setObject:model.skuName forKey:@"skuName"];
                 }
                 
                 if (model.userCarId) {
                     [extraDic setObject:model.userCarId forKey:@"userCarId"];
                 }
                 if (model.userCarName) {
                     [extraDic setObject:model.userCarName forKey:@"userCarName"];
                 }
                 if (model.reDate) {
                     [extraDic setObject:model.reDate forKey:@"lastDate"];
                 }
                 model.extraParams = extraDic;
                 [resultArray addObject:model];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取订单列表失败");
         }
     }];
}

//支付完成
+ (void)finishPayWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/complete";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"支付失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"支付完成",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"支付失败",NO);
         }
     }];
}

//退款
+ (void)refundWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/refund";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"申请退款失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"申请退款成功",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"申请退款失败",NO);
         }
     }];
}

//提交评论
+ (void)submitCommitWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"comment/add";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"提交评论失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"提交评论成功",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"提交评论失败",NO);
         }
     }];
}

//删除订单
+ (void)deleteTradeWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/del";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"删除失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"删除成功",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"删除失败",NO);
         }
     }];
}

//设置默认维修店
+ (void)setUserDefaultShopWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/changeShop";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"设置失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"设置成功",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"设置失败",NO);
         }
     }];
}

//获取首页轮播图
+ (void)getFirstImagesWithBlock:(void(^)(NSArray *resultArr,NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"slides";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取图片失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] init];
         NSArray *slidesArr = [responseObject objectForKey:@"slides"];
         if (slidesArr.count > 0) {
             for (NSDictionary *item in slidesArr) {
                 ImageModel *model = [[ImageModel alloc] init];
                 model.imgId = [NSString stringWithFormat:@"%@",item[@"index"]];
                 model.imgType = [NSString stringWithFormat:@"%@",item[@"type"]];
                 model.imgUrl = item[@"img"];
                 
                 if (item[@"volumeId"]) {
                     model.volumeId = [NSString stringWithFormat:@"%@",item[@"volumeId"]];
                 }
                 
                 if (item[@"skuId"]) {
                     model.skuId = [NSString stringWithFormat:@"%@",item[@"skuId"]];
                 }
                 
                 if (item[@"htmlUrl"]) {
                     model.htmlUrl = item[@"htmlUrl"];
                 }
                 [resultArray addObject:model];
             }
         }
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取图片失败");
         }
     }];
}

//修改用户头像
+ (void)setUserHeaderWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic fileData:(NSData *)imgData
{
    NSString *urlString = @"user/changeIcon";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imgData name:@"icon" fileName:@"icon.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [responseObject objectForKey:kResultCode];
        
        if (![resultCode isEqualToString:kSuccessCode]) {
            NSString *errorStr = @"头像设置失败";
            if ([responseObject objectForKey:kResultMsg]) {
                if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                    errorStr = [responseObject objectForKey:kResultMsg];
                }
            }
            
            if (block) {
                block(errorStr,NO);
            }
            return;
        }
        
        //请求成功
        if (block) {
            block(@"头像设置成功",YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(@"头像设置失败",NO);
        }
    }];
//    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         
//         NSString *resultCode = [responseObject objectForKey:kResultCode];
//         
//         if (![resultCode isEqualToString:kSuccessCode]) {
//             NSString *errorStr = @"头像设置失败";
//             if ([responseObject objectForKey:kResultMsg]) {
//                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
//                     errorStr = [responseObject objectForKey:kResultMsg];
//                 }
//             }
//             
//             if (block) {
//                 block(errorStr,NO);
//             }
//             return;
//         }
//         
//         //请求成功
//         if (block) {
//             block(@"头像设置成功",YES);
//         }
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         if (block) {
//             block(@"头像设置失败",NO);
//         }
//     }];
}

//获取商品列表
+ (void)getGoodsListWithBlock:(void(^)(NSArray *resultArray, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"car/skusByVolumeId";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取商品列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSMutableArray *resultArray = [[NSMutableArray alloc] init];
         NSArray *goodsArr = [responseObject objectForKey:@"skus"];
         if (goodsArr.count > 0) {
             for (NSDictionary *item in goodsArr) {
                 GoodsModel *model = [[GoodsModel alloc] init];
                 
                 model.goodsId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                 model.goodsName = [item objectForKey:@"title"];
                 model.originPrice = [NSString stringWithFormat:@"%@",[item objectForKey:@"priceOld"]];
                 model.goodsPrice = [NSString stringWithFormat:@"%@",[item objectForKey:@"price"]];
                 model.commentNum = [NSString stringWithFormat:@"%@",[item objectForKey:@"commentNum"]];
                 model.commentScore = [NSString stringWithFormat:@"%@",[item objectForKey:@"score"]];
                 
                 model.afterSales = [item objectForKey:@"afterSales"];
                 model.intr = [item objectForKey:@"intr"];
                 model.packageList = [item objectForKey:@"packageList"];
                 model.parameters = [item objectForKey:@"parameters"];
                 model.offers = [item objectForKey:@"offers"];
                 model.repertory = [NSString stringWithFormat:@"%@",[item objectForKey:@"repertory"]];
                 model.suitCar = [item objectForKey:@"allName"];
                 model.volumeId = [NSString stringWithoutNil:[item objectForKey:@"volumeId"]];
                 
                 model.maxValue = [[NSString stringWithFormat:@"%@",[item objectForKey:@"maxValue"]] integerValue];
                 NSString *priceFirstDiscount = [NSString stringWithFormat:@"%@",item[@"priceFirstDiscount"]];
                 if (![NSString isBlankString:priceFirstDiscount]) {
                     model.priceFirstDiscount = [priceFirstDiscount integerValue];
                 }
                 
                 //大图
                 NSString *iconUrls = [item objectForKey:@"icon"];
                 if (![NSString isBlankString:iconUrls]) {
                     model.goodsIconArr = [iconUrls componentsSeparatedByString:@","];
                 }
                 
                 if (model.goodsIconArr.count > 0) {
                     model.goodsIcon = model.goodsIconArr[0];
                 }
                 
                 [resultArray addObject:model];
             }
         }
         
         if (block) {
             block(resultArray,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"获取商品列表失败");
         }
     }];
}

//多个商品生成订单
+ (void)addNewTradeWithBlock:(void(^)(OrderModel *model, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/add2";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"生成订单失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(nil,errorStr);
             }
             return;
         }
         
         //请求成功
         NSDictionary *tradeDic = [responseObject objectForKey:@"trade"];
         OrderModel *model = [[OrderModel alloc] init];
         model.tradeNO = [NSString stringWithFormat:@"%@",tradeDic[@"id"]];
         model.shopId = [NSString stringWithFormat:@"%@",tradeDic[@"shopId"]];
         model.skuId = [NSString stringWithFormat:@"%@",tradeDic[@"skuId"]];
         model.userCarId = [NSString stringWithFormat:@"%@",tradeDic[@"userCarId"]];
         model.userId = [NSString stringWithFormat:@"%@",tradeDic[@"userId"]];
         model.shopName = tradeDic[@"shopName"];
         model.skuName = tradeDic[@"skuName"];
         model.userCarName = tradeDic[@"userCarName"];
         model.priceStr = [NSString stringWithFormat:@"%@",tradeDic[@"amount"]];
         model.reDate = [NSString convertMsToDateString:[NSString stringWithFormat:@"%@",tradeDic[@"lastDate"]]];
         model.orderStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"dstatus"]] integerValue];
         model.payStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"payStatus"]] integerValue];
         model.wuliuStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"wuliuStatus"]] integerValue];
         model.iconUrl = tradeDic[@"iconUrl"];
         
         if (tradeDic[@"wuliuSN"]) {
             model.goodWuliusn = [NSString stringWithFormat:@"%@",tradeDic[@"wuliuSN"]];
         }
         
         if (tradeDic[@"invoiceSN"]) {
             model.billWulius = [NSString stringWithFormat:@"%@",tradeDic[@"invoiceSN"]];
         }
         
         //skus
         NSArray *tmpSkuArr = tradeDic[@"skus"];
         if (tmpSkuArr > 0) {
             NSMutableArray *skuArr = [[NSMutableArray alloc] init];
             for (NSDictionary *tmpItem in skuArr) {
                 GoodsModel *model = [[GoodsModel alloc] init];
                 
                 //大图
                 NSString *iconUrls = [tmpItem objectForKey:@"icon"];
                 if (![NSString isBlankString:iconUrls]) {
                     model.goodsIconArr = [iconUrls componentsSeparatedByString:@","];
                 }
                 
                 if (model.goodsIconArr.count > 0) {
                     model.goodsIcon = model.goodsIconArr[0];
                 }
                 model.goodsId = [NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"skuId"]];
                 
                 model.goodsNum = [[NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"num"]] integerValue];
                 
                 model.goodsName = [tmpItem objectForKey:@"skuName"];
                 
                 model.goodsPrice = [NSString stringWithFormat:@"%@",[tmpItem objectForKey:@"price"]];
                 
                 [skuArr addObject:model];
             }
             model.goodsArr = [skuArr copy];
         }
         
         model.invoiceStatus = [[NSString stringWithFormat:@"%@",tradeDic[@"invoiceStatus"]] integerValue];
         model.wuliuName = tradeDic[@"wuliuName"];
         model.wuliuPhone = tradeDic[@"wuliuPhone"];
         model.addressId = [NSString stringWithFormat:@"%@",tradeDic[@"addressId"]];
         model.detailAddr = tradeDic[@"address"];
         model.province = tradeDic[@"province"];
         model.city = tradeDic[@"city"];
         
         NSMutableDictionary *extraDic = [[NSMutableDictionary alloc] init];
         
         
         if (model.goodsArr.count > 0) {
             [extraDic setObject:model.goodsArr forKey:@"skus"];
         }
         if (model.wuliuName) {
             [extraDic setObject:model.skuId forKey:@"wuliuName"];
         }
         if (model.wuliuPhone) {
             [extraDic setObject:model.skuId forKey:@"wuliuPhone"];
         }
         if (model.addressId) {
             [extraDic setObject:model.skuId forKey:@"addressId"];
         }
         if (model.detailAddr) {
             [extraDic setObject:model.skuId forKey:@"address"];
         }
         if (model.province) {
             [extraDic setObject:model.skuId forKey:@"province"];
         }
         if (model.city) {
             [extraDic setObject:model.skuId forKey:@"city"];
         }
         if (model.skuId) {
             [extraDic setObject:model.skuId forKey:@"skuId"];
         }
         if (model.skuName) {
             [extraDic setObject:model.skuName forKey:@"skuName"];
         }
         
         if (model.userCarId) {
             [extraDic setObject:model.userCarId forKey:@"userCarId"];
         }
         if (model.userCarName) {
             [extraDic setObject:model.userCarName forKey:@"userCarName"];
         }
         if (model.reDate) {
             [extraDic setObject:model.reDate forKey:@"lastDate"];
         }
         
         model.extraParams = extraDic;
         
         if (block) {
             block(model,nil);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(nil,@"生成订单失败");
         }
     }];
}


//获取地址列表
+ (void)getAddressListWithBlock:(void(^)(NSArray *resultArr, NSString *errorStr))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/getAddresses";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
     {
         NSString *retCode = responseObject[@"resultCode"];
         
         if ([retCode isEqualToString:kSuccessCode])
         {
             NSMutableArray *returnArray = [[NSMutableArray alloc]init];
             
             NSMutableArray *addressArr = responseObject[@"addresses"];
             
             for (NSDictionary *dic in addressArr)
             {
                 AddressModel *model = [[AddressModel alloc]init];
                 model.addressId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                 model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                 model.phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
                 model.province = [NSString stringWithFormat:@"%@",dic[@"province"]];
                 model.city = [NSString stringWithFormat:@"%@",dic[@"city"]];
                 model.detailAddr = [NSString stringWithFormat:@"%@",dic[@"address"]];
                 model.isDefault = [dic[@"active"] boolValue];
                 [returnArray addObject:model];
             }
             if (block)
             {
                 block(returnArray,nil);
             }
         }
         else
         {
             NSString *errorStr = @"获取地址列表失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             if (block)
             {
                 block(nil,errorStr);
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (block)
         {
             block(nil,@"获取地址列表失败");
         }
     }];
}

//添加地址
+ (void)addNewAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/addAddress";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"添加地址失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil,YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"添加地址失败",NO);
         }
     }];
}

//修改地址
+ (void)editAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/editAddress";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"修改地址失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil,YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"修改地址失败",NO);
         }
     }];
}

//设置常用地址
+ (void)setDefaultAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/activeAddress";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"设置常用地址失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil,YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"设置常用地址失败",NO);
         }
     }];
}

//获取常用地址
+ (void)getDefaultAddressWithBlock:(void(^)(NSString *errorStr,AddressModel *defaultModel))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/getActiveAddress";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"获取常用地址失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,nil);
             }
             return;
         }
         
         //请求成功
         AddressModel *model = [[AddressModel alloc] init];
         NSArray *addresses = [responseObject objectForKey:@"addresses"];
         
         if (addresses.count > 0) {
             NSDictionary *dic = addresses[0];
             if (dic) {
                 model.addressId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                 model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                 model.phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
                 model.province = [NSString stringWithFormat:@"%@",dic[@"province"]];
                 model.city = [NSString stringWithFormat:@"%@",dic[@"city"]];
                 model.detailAddr = [NSString stringWithFormat:@"%@",dic[@"address"]];
                 model.isDefault = [dic[@"active"] boolValue];
             }
         }
         
         if (block) {
             block(nil,model);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"获取常用地址失败",nil);
         }
     }];
}

//删除地址
+ (void)deleteAddressWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"user/delAddress";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"删除地址失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(nil,YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"删除地址失败",NO);
         }
     }];
}

//索要发票
+ (void)sendBillInfoWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/blagInvoice";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"索要发票失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"索要发票成功",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"索要发票失败",NO);
         }
     }];
}

//确认收货
+ (void)confirmTradeWithBlock:(void(^)(NSString *errorStr,BOOL isSuccess))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"trade/complete";
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             NSString *errorStr = @"确认失败";
             if ([responseObject objectForKey:kResultMsg]) {
                 if (![NSString isBlankString:[responseObject objectForKey:kResultMsg]]) {
                     errorStr = [responseObject objectForKey:kResultMsg];
                 }
             }
             
             if (block) {
                 block(errorStr,NO);
             }
             return;
         }
         
         //请求成功
         if (block) {
             block(@"确认收货",YES);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(@"确认失败",NO);
         }
     }];
}

@end
