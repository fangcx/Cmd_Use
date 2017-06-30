//
//  AddressModel.h
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, strong)NSString *addressId;
@property (nonatomic, strong)NSString *province;    //省份
@property (nonatomic, strong)NSString *city;        //城市
@property (nonatomic, strong)NSString *detailAddr;  //详细地址
@property (nonatomic, strong)NSString *name;        //收件人姓名
@property (nonatomic, strong)NSString *phone;       //收件人电话
@property (nonatomic ,assign)BOOL isDefault;        //是否默认地址

@end
