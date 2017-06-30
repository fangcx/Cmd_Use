//
//  AddressModel.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (id)init
{
    self = [super init];
    if (self) {
        _isDefault = NO;
        _province = @"";
        _city = @"";
        _detailAddr = @"";
        _name = @"";
        _phone = @"";
    }
    return self;
}

@end
