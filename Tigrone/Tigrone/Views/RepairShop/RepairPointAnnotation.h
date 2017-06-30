//
//  RepairPointAnnotation.h
//  Tigrone
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RepairShopModel.h"

@interface RepairPointAnnotation : BMKPointAnnotation

@property (nonatomic, strong)RepairShopModel *repairModel;

@end
