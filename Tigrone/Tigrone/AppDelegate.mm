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
#import "YGuideView.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AuthRequests.h"


@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    //
    [CoreUtils openDDLog];
    [CoreUtils startMonitorNetwork];
    
    //start baiduMap
    [self startBaiduMap];
    
    if ([self isNeedLogin]) {
        [self goLoginViewController];
    }
    else
    {
        [self goMainViewController];
    }
    
    //首次登录进入引导页面
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:FIRST_USER_NO])
    {
        [self goGuideView];
    }
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
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
        self.mainTabBarViewController.tabBar.selectedImageTintColor = Tigrone_SchemeColor;
        self.mainTabBarViewController.tabBar.barTintColor = [UIColor whiteColor];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorWithHexValue(0x999999), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Tigrone_SchemeColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        [self setNavgationBarStyle];
    }
    
    self.window.rootViewController = self.mainTabBarViewController;
}

- (void)goLoginViewController
{
    if (self.loginNavViewController == nil)
    {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        self.loginNavViewController = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginNav"];
        [self setNavgationBarStyle];
    }
    
    if (self.loginNavViewController.viewControllers.count > 0) {
        LoginViewController *loginVc = self.loginNavViewController.viewControllers[0];
        loginVc.isCanceLogin = YES;
    }
    
    self.window.rootViewController = self.loginNavViewController;
    
    if (self.loginNavViewController.viewControllers.count > 1)
    {
        [self.loginNavViewController popToRootViewControllerAnimated:YES];
    }
}

- (void)setNavgationBarStyle
{
    [[UINavigationBar appearance] setBarTintColor:Tigrone_SchemeColor]; // 导航栏背景色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//默认navgationItem的字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//导航栏 title颜色
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //去掉导航栏底部黑线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - startBaiduMap
- (void)startBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:kBaiduMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark -baduMapDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)isNeedLogin
{
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    if ([NSString isBlankString:token]) {
//        return YES;
//    }
//    else
//    {
//        Token = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//        PhoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
//        [GlobalData shareInstance].userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
//        return NO;
//    }
    
    Token = [NSString stringWithoutNil:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    PhoneNum = [NSString stringWithoutNil:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"]];
    [GlobalData shareInstance].userId = [NSString stringWithoutNil:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    if (![NSString isBlankString:Token] && ![NSString isBlankString:PhoneNum]) {
        TIsLogin = YES;
        //校验token
        [self checkTokenRequest];
    }
    
    return NO;
}

- (void)goGuideView
{
    YGuideView *guidView =[[YGuideView alloc]initWithFrame:CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height)];
    guidView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:guidView];
    [self.window bringSubviewToFront:guidView];
}

#pragma mark - request
- (void)checkTokenRequest
{
    [AuthRequests checkTokenWithBlock:^(BOOL isExist) {
        TIsLogin = isExist;
        [[NSNotificationCenter defaultCenter] postNotificationName:CheckTokenNof object:nil];
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

@end
