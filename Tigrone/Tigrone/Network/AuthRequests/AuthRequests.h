//
//  AuthRequests.h
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthRequests : NSObject

+ (void)getRegisterCheckCodeWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)registerRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)changePasswdRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;


+ (void)loginWithPasswordRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)getLoginCheckCodeWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)loginWithCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)loginOutRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)getForgetPasswordCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

+ (void)checkForgetPasswordCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic;

//token是否存在
+ (void)checkTokenWithBlock:(void (^)(BOOL isExist))block paramDic:(NSDictionary *)paramDic;


@end
