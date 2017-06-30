//
//  AppDelegate.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/12.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FirstPageViewContoller.h"
#import "RepairShopViewController.h"
#import "ShoppingCartViewController.h"
#import "MeViewController.h"

#import "CoreUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    //
    [CoreUtils openDDLog];
    [CoreUtils startMonitorNetwork];
    
    //
//    [self goLoginViewController];
    [self goMainViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Enter ViewController 
- (void)goMainViewController
{
    if (self.mainTabBarViewController == nil) {
        UIStoryboard *FirstPageStoryBoard    = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
        UIStoryboard *RepairShopStoryBoard   = [UIStoryboard storyboardWithName:@"RepairShop" bundle:nil];
        UIStoryboard *shoppingCartStoryBoard = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
        UIStoryboard *MeStoryBoard           = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        
        UINavigationController *firstPageNav    = [FirstPageStoryBoard instantiateViewControllerWithIdentifier:@"firstPageNav"];
        firstPageNav.tabBarItem.title           = @"首页";
        firstPageNav.tabBarItem.image           = [UIImage imageNamed:@"common_main_icon_off"];
        
        UINavigationController *repariShopNav   = [RepairShopStoryBoard instantiateViewControllerWithIdentifier:@"RepairShopNav"];
        repariShopNav.tabBarItem.title          = @"维修店";
        repariShopNav.tabBarItem.image          = [UIImage imageNamed:@"common_repair_icon_off"];
        
        UINavigationController *shoppingCartNav = [shoppingCartStoryBoard instantiateViewControllerWithIdentifier:@"ShoppingCartNav"];
        shoppingCartNav.tabBarItem.title        = @"购物车";
        shoppingCartNav.tabBarItem.image        = [UIImage imageNamed:@"common_cart_icon_off"];
        
        UINavigationController *meNav           = [MeStoryBoard instantiateViewControllerWithIdentifier:@"MeNav"];
        meNav.tabBarItem.title                  = @"我";
        meNav.tabBarItem.image                  = [UIImage imageNamed:@"common_me_icon_off"];
        
        self.mainTabBarViewController = [[UITabBarController alloc] init];
        self.mainTabBarViewController.viewControllers = @[firstPageNav,repariShopNav,shoppingCartNav,meNav];
        self.mainTabBarViewController.tabBar.selectedImageTintColor = [UIColor yellowColor];
        self.mainTabBarViewController.tabBar.barTintColor = Tigrone_SchemeColor;
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        [[UINavigationBar appearance] setBarTintColor:Tigrone_SchemeColor]; // 导航栏背景色
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//默认navgationItem的字体颜色
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏 title颜色
    }
    
    self.window.rootViewController = self.mainTabBarViewController;
}

- (void)goLoginViewController
{
    if (self.loginNavViewController == nil)
    {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        self.loginNavViewController = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginNav"];
        
        [[UINavigationBar appearance] setBarTintColor:Tigrone_SchemeColor]; // 导航栏背景色
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//默认navgationItem的字体颜色
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏 title颜色
    }
    self.window.rootViewController = self.loginNavViewController;
}

@end
