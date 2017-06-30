//
//  BillViewController.h
//  Tigrone
//
//  Created by Mac on 16/3/5.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"
#import "BaseViewContoller.h"
#import "OrderModel.h"

@interface BillViewController : BaseViewContoller

@property (nonatomic, strong)OrderModel *orderModel;

@end
