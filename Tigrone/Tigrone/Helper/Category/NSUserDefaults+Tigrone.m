//
//  NSUserDefaults+Tigrone.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "NSUserDefaults+Tigrone.h"

static NSString * const kisNotFirstUse = @"kisNotFirstUse";
static NSString * const kIsLogined  = @"kIsLogined";
static NSString * const kLoginedWithPssword  = @"kLoginedWithPssword";

@implementation NSUserDefaults (Tigrone)


+ (void)saveisNotFirstUse:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kisNotFirstUse];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isNotFirstUse
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kisNotFirstUse];
}

+ (void)saveIsLogined:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kIsLogined];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogined
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined];
}

+ (void)saveLoginWithPassword:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kLoginedWithPssword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLoginWithPassword
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoginedWithPssword];
}


@end
