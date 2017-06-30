//
//  AreaOperations.h
//  Tigrone
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"

@interface AreaOperations : NSObject

//查询当前选中的城市
+ (AreaModel *)getCurrentCity;

//设置当前城市
+ (BOOL)setCurrentCity:(AreaModel *)model;

@end
