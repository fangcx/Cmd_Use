//
//  SelectRepairViewController.h
//  Tigrone
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"
#import "RepairShopModel.h"

@protocol SelectRepairShopDelegate <NSObject>

- (void)didSelectRepairShop:(RepairShopModel *)model;

@end

@interface SelectRepairViewController : BaseViewContoller

@property (nonatomic, assign)id <SelectRepairShopDelegate>delegate;
@property (nonatomic, strong)RepairShopModel *selectModel;

@end
