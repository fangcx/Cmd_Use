//
//  UserInfoModel.h
//  Tigrone
//
//  Created by ZhangLiang on 16/1/11.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic ,strong)NSString *userId;
@property (nonatomic, strong)NSString *userIcon;
@property (nonatomic ,strong)NSString *userCityId;
@property (nonatomic ,strong)NSString *createdDate;
@property (nonatomic ,strong)NSString *lastDate;
@property (nonatomic ,strong)NSString *userName;
@property (nonatomic ,strong)NSString *userPhone;
@property (nonatomic ,strong)NSString *userEmail;
@property (nonatomic, strong)NSString *shopId;
@property (nonatomic, strong)NSString *shopName;
@property (nonatomic, strong)NSString *shopAddr;

@end
