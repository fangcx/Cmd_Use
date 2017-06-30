//
//  OrderDetailViewController.h
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/23.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"
#import "OrderModel.h"

@interface OrderDetailViewController : BaseViewContoller

@property (nonatomic, strong)OrderModel *orderModel;
@property (nonatomic, assign)BOOL isFinish;

@end
