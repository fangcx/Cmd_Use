//
//  NSString+Tigrone.m
//  Tigrone
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "NSString+Tigrone.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommonMacro.h"

@implementation NSString (Tigrone)

+ (NSString*)stringWithoutNil:(id)str
{
    if (str) {
        NSString *tempStr = [NSString stringWithFormat:@"%@",str];
        return [NSString isBlankString:tempStr]?@"":tempStr;
    }else{
        return @"";
    }
}

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}

+(NSString *)convertMsToTimeString:(NSString *)timeString
{
    long long secFrom1970 = [timeString longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secFrom1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)convertMsToDateString:(NSString *)timeString
{
    long long secFrom1970 = [timeString longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secFrom1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

// 数据库特殊字符处理
+ (NSString *)stringSqlEscape:(NSString *)str
{
    if (str)
    {
        str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    return str;
}

+ (NSString *)phonetic:(NSString *)sourceString
{
    NSMutableString *source = [sourceString mutableCopy];
    
    /*Transformation	                 Input	        Output
     *********************************************************
     CFString​Transform: wiki http://nshipster.com/cfstringtransform/
     kCFStringTransformMandarinLatin	中文	            zhōng wén
     kCFStringTransformStripDiacritics  zhōng wén       zhong wen
     kCFStringTransformToLatin          中文 or chinese  zhōng wén or chinese
     */
    //string参数是要转换的string，比如要转换的中文，同时它是mutable的，因此也直接作为最终转换后的字符串。
    //range是要转换的范围，同时输出转换后改变的范围，如果为NULL，视为全部转换。
    //transform可以指定要进行什么样的转换，这里可以指定多种语言的拼写转换。
    //reverse指定该转换是否必须是可逆向转换的。如果转换成功就返回true，否则返回false
    Boolean isFinish = CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformToLatin, NO);
    //    DDLogInfo(@"第一步转换%@:------>\n%@",isFinish?@"成功":@"失败",source);
    isFinish = CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    //    DDLogInfo(@"第二步转换%@:------>\n%@",isFinish?@"成功":@"失败",source);
    return source;
}

//clear space in parseString
+ (NSString *)clearSpace:(NSString *)parseString
{
    NSString *clearSpace = [parseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return clearSpace;
}

+ (NSString *)clearEnter:(NSString *)parseString
{
    NSString *clearSpace1 = [parseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *clearSpace2 = [clearSpace1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return clearSpace2;
}

//add enter at the end of parseString
+ (NSString *)addEnter:(NSString *)parseString;
{
    NSString *addEnter =  [parseString stringByAppendingString:@"\r\n"];
    return addEnter;
}

//splict string to word by space
+ (NSMutableArray *)buildStringBySplitSpace:(NSString *)inputString
{
    int count_index = 0;
    int beginWordindex = -1;
    int endWordindex = -1;
    NSMutableArray *splictWords = [NSMutableArray array];
    NSString *splictString;
    while(count_index< [inputString length])
    {
        if([inputString characterAtIndex:count_index]  == 32)
        {
            count_index ++;
        }
        else
        {
            if (beginWordindex == -1)
            {
                beginWordindex = count_index;
                if([inputString characterAtIndex:count_index + 1]  == 32 && [inputString characterAtIndex:count_index + 2]  == 32 && [inputString characterAtIndex:count_index + 3]  == 32)
                {
                    endWordindex = count_index;
                    splictString = [inputString substringWithRange:NSMakeRange(beginWordindex, endWordindex - beginWordindex + 1)];
                    [splictWords addObject:splictString];
                    beginWordindex = -1;
                }
                count_index ++;
            }
            else
            {
                if (count_index + 1 == [inputString length])
                {
                    count_index ++;
                }
                else
                {
                    if([inputString characterAtIndex:count_index + 1]  == 32 && [inputString characterAtIndex:count_index + 2]  == 32 && [inputString characterAtIndex:count_index + 3]  == 32)
                    {
                        endWordindex = count_index;
                        splictString = [inputString substringWithRange:NSMakeRange(beginWordindex, endWordindex - beginWordindex + 1)];
                        [splictWords addObject:splictString];
                        beginWordindex = -1;
                    }
                    count_index ++;
                }
            }
        }
    }
    return splictWords;
}

//replace string
+ (NSString *)buildStringByReplace:(NSString *)originalString To:(NSString *)replaceString  FromString:(NSString *) fromString;
{
    NSString*text = nil ;
    NSString *result = [fromString stringByReplacingOccurrencesOfString:
                        [ NSString stringWithFormat:originalString, text]
                                                             withString:replaceString];
    return result;
}

+ (NSMutableArray *)buildStringIntoGroupByWord:(NSString *) inputWord Index:(int) index From:(NSArray *)inputArray
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for(int i = 0; i<[inputArray count]; i++)
    {
        if ([[inputArray objectAtIndex:i] characterAtIndex:index] == [inputWord characterAtIndex:0])
        {
            [result addObject:[inputArray objectAtIndex:i]];
        }
    }
    return result;
}

+ (NSString *)buildStringByStartIndex:(int)startindex EndIndex:(int)endindex FromString:(NSString *)string
{
    NSString *resultString;
    if (startindex != -1 && endindex != -1)
    {
        resultString = [string substringWithRange:NSMakeRange(startindex,endindex - startindex+1)];
    }
    else if(startindex != -1 && endindex == -1)
    {
        resultString = [string substringFromIndex:startindex];
    }
    else if(startindex == -1 && endindex != -1)
    {
        resultString = [string substringToIndex:endindex];
    }
    else
    {
        resultString = @"";
    }
    return resultString;
}

+ (NSString *)md5FromString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    NSString * MOBILE = @"^((13[0-9])|(147)|(177)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isMailAddress:(NSString *)mailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mailString];
}

+ (BOOL)isID:(NSString *)idString
{
    if (idString.length <= 0)
    {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idString];
}

+ (BOOL)isPassWord:(NSString *)passWordString
{
    if (passWordString.length <= 0)
    {
        return NO;
    }
    
    NSString * regex = REGEX_NAME;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:passWordString];
}

+ (NSString *)getJsonStringWith:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (!jsonData)
    {
        return nil;
    }
    else
    {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes]
                                                        length:[jsonData length]
                                                      encoding:NSUTF8StringEncoding];
        return JSONString;
    }
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

@end
