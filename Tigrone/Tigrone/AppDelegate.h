//
//  AppDelegate.h
//  Tigrone
//
//  Created by ZhangGang on 15/11/12.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#define APPDELEGATE   ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)UITabBarController     *mainTabBarViewController;
@property (strong, nonatomic)UINavigationController *loginNavViewController;

- (void)goMainViewController;

- (void)goLoginViewController;

@end

