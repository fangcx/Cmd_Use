//
//  SelectCityViewController.h
//  Tigrone
//
//  Created by Mac on 15/12/22.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"
#import "AreaModel.h"

@interface SelectCityViewController : BaseViewContoller

@property (nonatomic, strong)AreaModel *selectModel;

@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)NSString *localCity;

@end
