//
//  MBProgressHUD+Tigrone.h
//  Tigrone
//
//  Created by 张刚 on 15/12/22.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Tigrone)

//Show HUD
+ (MBProgressHUD *)showHUDWithMsg:(NSString *)message toView:(UIView *)view;

//Hide HUD
+ (void)hideHUDForView:(UIView *)view;

//Show HUD to alert network is bad, hide after 1s
+ (MBProgressHUD *)showHUDForNetWorkUnavailableToView:(UIView *)view;

//Show HUD, hide after duration time
+ (MBProgressHUD *)showHUDAWhile:(NSString *)message toView:(UIView *)view duration:(NSTimeInterval)duration;


@end
