//
//  BillModel.h
//  Tigrone
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic, strong)NSString *invoiceType;         //类别
@property (nonatomic, strong)NSString *invoiceTitle;        //抬头
@property (nonatomic, strong)NSString *invoiceContext;      //内容

@end
