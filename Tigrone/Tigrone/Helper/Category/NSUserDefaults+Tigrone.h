//
//  NSUserDefaults+Tigrone.h
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Tigrone)

/**
 *  保存是否第一次使用本App的BOOL值
 *
 *  @param value 表明是否第一次使用的BOOL值
 */
+ (void)saveisNotFirstUse:(BOOL)value;


+ (BOOL)isNotFirstUse;

/**
 *  保存是否已经登录的BOOL值
 *
 *  @param value 表明是否已经登录BOOL值
 */
+ (void)saveIsLogined:(BOOL)value;

+ (BOOL)isLogined;


/**
 *  保存是否用密码登录
 *
 *  @param value YES,表示用密码登录，反之。
 */
+ (void)saveLoginWithPassword:(BOOL)value;

+ (BOOL)isLoginWithPassword;


@end
