//
//  GoodsModel.m
//  Tigrone
//
//  Created by Mac on 16/1/11.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

- (id)init
{
    self = [super init];
    if (self) {
        _goodsIcon = @"";
        _goodsNum = 1;
        _priceFirstDiscount = 0;
        _isSelected = NO;
    }
    return self;
}

@end
