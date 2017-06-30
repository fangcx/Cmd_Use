//
//  CommonMacro.h
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

/*************************************************************************************************/
#pragma mark - Frame macro
/*************************************************************************************************/
#define kMainScreenFrameRect                          [[UIScreen mainScreen] bounds]
#define kMainScreenHeight                             kMainScreenFrameRect.size.height
#define kMainScreenWidth                              kMainScreenFrameRect.size.width
#define kMainScreenStatusBarFrameRect                 [[UIApplication sharedApplication] statusBarFrame]

/*************************************************************************************************/
#pragma mark - Color macro
/*************************************************************************************************/
#define ColorWithRGB(r, g, b)       [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha:1.0]
#define ColorWithRGBA(r, g, b, a)   [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha:(a)]
#define ColorWithHexValue(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define ColorWithHexAndAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

/*************************************************************************************************/
#pragma mark - Path macro
/*************************************************************************************************/
#define HomePath NSHomeDirectory()
#define CachePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define LibraryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define TempPath NSTemporaryDirectory()
#define MainBoundPath [[NSBundle mainBundle] bundlePath]

/*************************************************************************************************/
#pragma mark - App Info macro
/*************************************************************************************************/
//Current iOS Version
#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

//Current Sys Language
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//Current App Version
#define APP_VERSION   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

//Current App Name
#define APP_NAME      ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

//Default date string format
#define  DEFAULT_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")

#define IMAGE(name) [UIImage imageNamed:(name)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *
 * REGEX macros
 *
 **/
#define REGEX_EMAIL         @"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*\" + \"+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"
#define REGEX_NAME          @"(^[\u4e00-\u9fa5]|[a-z]|[A-Z])[\u4e00-\u9fa5|a-z|A-Z|0-9|\\.|_|\\s]{6,16}[\u4e00-\u9fa5|a-z|A-Z|0-9|\\.|_]$"

/*************************************************************************************************/
#pragma mark - Methods macro
/*************************************************************************************************/
#define Tg_dispatch_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//非首次进入
#define FIRST_USER_NO           @"FIRST_USER_NO"

/**
 *
 * keyChain
 *
 **/

#define KEY_USERNAME  @"com.Tigrone.username"
#define KEY_PASSWORD  @"com.Tigrone.password"

/**
 *
 * Tigrone macros
 *
 **/
#define   Tigrone_SchemeColor  ColorWithHexValue(0x1B57A9)

#define kBaiduMapKey @"p7Pv7INyBS3gyPcYjeZOAoFg"


/**
 *
 *request string
 *
 **/

#define TUserId     [GlobalData shareInstance].userId
#define Token      [GlobalData shareInstance].token
#define PhoneNum   [GlobalData shareInstance].phoneNum

#define CURRENTLOC  [GlobalData shareInstance].currentCoor

#define USERLOC     [GlobalData shareInstance].userLocation

#define TIsLogin    [GlobalData shareInstance].isLogin

#define CheckTokenNof   @"CheckTokenNof"

#define kResultCode   @"resultCode"
#define kSuccessCode  @"0"
#define kResultMsg    @"resultMsg"


