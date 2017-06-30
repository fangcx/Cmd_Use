//
//  MaintainPointViewController.h
//  Tigrone
//
//  Created by 张亮 on 15/12/27.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"
#import "OrderModel.h"

@interface RepairPointViewController : BaseViewContoller

@property (nonatomic, assign)NSUInteger goodScore;
@property (nonatomic, strong)NSString *commentStr;
@property (nonatomic, strong)OrderModel *orderModel;

@end
