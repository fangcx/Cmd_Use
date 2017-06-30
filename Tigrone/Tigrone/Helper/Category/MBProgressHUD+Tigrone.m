//
//  MBProgressHUD+Tigrone.m
//  Tigrone
//
//  Created by 张刚 on 15/12/22.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MBProgressHUD+Tigrone.h"

#define ALERT_NO_NETWORK             NSLocalizedString(@"抱歉，当前没有网络。", @"")

@implementation MBProgressHUD (Tigrone)

+ (MBProgressHUD *)showHUDWithMsg:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (MBProgressHUD *)showHUDForNetWorkUnavailableToView:(UIView *)view
{
    MBProgressHUD *hud = [self showHUDAWhile:ALERT_NO_NETWORK toView:view duration:1];
    return hud;
}

+ (MBProgressHUD *)showHUDAWhile:(NSString *)message toView:(UIView *)view duration:(NSTimeInterval)duration
{
    if (view == nil) {
        return nil;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    
    [hud hide:YES afterDelay:duration];
    return hud;
}

@end
