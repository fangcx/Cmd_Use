//
//  NSString+Tigrone.h
//  Tigrone
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")

@interface NSString (Tigrone)

+ (NSString*)stringWithoutNil:(id)str;

//Blank check
+ (BOOL)isBlankString:(NSString *)string;

// convert ms to  "yyyy-MM-dd HH:mm:ss"
+(NSString *)convertMsToTimeString:(NSString *)timeString;//时间毫秒数据 转换成 "yyyy-MM-dd HH:mm:ss"

// convert ms to  "yyyy-MM-dd"
+(NSString *)convertMsToDateString:(NSString *)timeString;

//convert chinese to pinyin
+ (NSString *)phonetic:(NSString *)sourceString;

//Build String
+ (NSString *)clearEnter:(NSString *)parseString; //清除字符串里的回车和换行
+ (NSString *)clearSpace:(NSString *)parseString; //清除字符串里的空格
+ (NSString *)addEnter:(NSString *)parseString;
+ (NSMutableArray *)buildStringBySplitSpace:(NSString *)inputString;
+ (NSString *)buildStringByReplace:(NSString *)originalString To:(NSString *)replaceString  FromString:(NSString *) fromString;
+ (NSMutableArray *)buildStringIntoGroupByWord:(NSString *) inputWord Index:(int) index From:(NSArray *)inputArray;
+ (NSString *)buildStringByStartIndex:(int)startindex EndIndex:(int)endindex FromString:(NSString *)string;

//MD5 Encode /key length is 16
+ (NSString *)md5FromString:(NSString *)str;

//Regular expression verification
+ (BOOL)isPhoneNumber:(NSString *)phoneString;
+ (BOOL)isMailAddress:(NSString *)mailString;
+ (BOOL)isID:(NSString *)idString;
+ (BOOL)isPassWord:(NSString *)passWordString;

//NSDictionary->json str
+ (NSString *)getJsonStringWith:(NSDictionary *)dic;

- (NSString *)URLEncodedString;

@end
