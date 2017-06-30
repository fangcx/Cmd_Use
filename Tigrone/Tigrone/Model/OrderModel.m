//
//  OrderModel.m
//  Tigrone
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)init
{
    self = [super init];
    if (self) {
        _tradeNO = @"2012113000001";
        _invoiceStatus = 0;
        _notifyURL = @"http://120.55.160.23/alipay/notify_url";
        _service = @"mobile.securitypay.pay";
        _paymentType = @"1";
        _inputCharset = @"utf-8";
//        _itBPay = @"30m";
//        _showUrl = @"m.alipay.com";
        _returnUrl = @"http://120.55.160.23/alipay/return_url";
    }
    return self;
}

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.skuName) {
        [discription appendFormat:@"&subject=\"%@\"", self.skuName];
    }
    
    if (self.priceStr) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.priceStr];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.returnUrl) {
        [discription appendFormat:@"&return_url=\"%@\"",self.returnUrl];
    }

//    if (self.appID) {
//        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
//    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}

@end
