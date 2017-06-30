//
//  RepairShopModel.m
//  Tigrone
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "RepairShopModel.h"

@implementation RepairShopModel

- (id)init
{
    self = [super init];
    if (self) {
        _shopIcon = @"";
        _shopPhone = @"";
        _shopCity = @"";
        _shopCounty = @"";
        _shopAddr = @"";
        _latitude = 0;
        _longtitude = 0;
        _commentNum = @"0";
        _businessTime = @"";
        _totalScore = @"";
        _serviceScore = @"";
        _skillScore = @"";
        _envirScore = @"";
        _commentNum = @"";
        _distanceStr = @"";
        _detailUrl = @"";
    }
    return self;
}

@end
