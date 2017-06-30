//
//  AuthRequests.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "AuthRequests.h"
#import "AppNetAPIClient.h"
#import "CommonMacro.h"
#import "GlobalData.h"
#import "NSString+Tigrone.h"

@implementation AuthRequests

+ (void)getRegisterCheckCodeWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/sendRegisterSms";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if (block){
            block(retCode,resultMsg,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"获取短信失败",error);
        }
    }];
}

+ (void)registerRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/register";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSDictionary *dic = responseObject[@"token"];
            Token = [NSString stringWithoutNil:[dic objectForKey:@"token"]];
            PhoneNum = [NSString stringWithoutNil:[dic objectForKey:@"phone"]];
            [GlobalData shareInstance].userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
        }
        
        if (block){
            block(retCode,resultMsg,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"注册失败",error);
        }
    }];
}

+ (void)changePasswdRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"changePasswd";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if (block){
            block(retCode,resultMsg,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"设置密码失败",error);
        }
    }];
}


+ (void)loginWithPasswordRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/loginIn";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSDictionary *dic = responseObject[@"token"];
            Token = [NSString stringWithoutNil:[dic objectForKey:@"token"]];
            PhoneNum = [NSString stringWithoutNil:[dic objectForKey:@"phone"]];
            [GlobalData shareInstance].userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
        }
        
        if (block){
            block(retCode,resultMsg,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"登录失败",error);
        }
    }];
}

+ (void)getLoginCheckCodeWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/sendLogInSms";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *retCode = responseObject[@"resultCode"];
         NSString *resultMsg = responseObject[@"resultMsg"];
         
         if (block){
             block(retCode,resultMsg,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (block){
             block(nil,@"获取短信失败",error);
         }
     }];
}

+ (void)loginWithCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/loginIn2";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = responseObject[@"resultCode"];
        NSString *resultMsg = responseObject[@"resultMsg"];
        
        if ([retCode isEqualToString:kSuccessCode])
        {
            NSDictionary *dic = responseObject[@"token"];
            Token = [NSString stringWithoutNil:[dic objectForKey:@"token"]];
            PhoneNum = [NSString stringWithoutNil:[dic objectForKey:@"phone"]];
            [GlobalData shareInstance].userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
        }
        
        if (block){
            block(retCode,resultMsg,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block){
            block(nil,@"登录失败",error);
        }
    }];
}

+ (void)loginOutRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/loginOut";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *retCode = responseObject[@"resultCode"];
         NSString *resultMsg = responseObject[@"resultMsg"];
         
         if (block){
             block(retCode,resultMsg,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (block){
             block(nil,nil,error);
         }
     }];
}

+ (void)getForgetPasswordCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/sendForgetSms";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *retCode = responseObject[@"resultCode"];
         NSString *resultMsg = responseObject[@"resultMsg"];
         
         if (block){
             block(retCode,resultMsg,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (block){
             block(nil,@"获取短信失败",error);
         }
     }];
}

+ (void)checkForgetPasswordCheckCodeRequestWithBlock:(void (^)(NSString *retcode,NSString *retmessage,NSError *error))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/validationSms";
    
    [[AppNetAPIClient sharedClient] POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *retCode = responseObject[@"resultCode"];
         NSString *resultMsg = responseObject[@"resultMsg"];
         
         if ([retCode isEqualToString:kSuccessCode])
         {
             NSDictionary *dic = responseObject[@"token"];
             Token = [NSString stringWithoutNil:[dic objectForKey:@"token"]];
             PhoneNum = [NSString stringWithoutNil:[dic objectForKey:@"phone"]];
         }
         
         if (block){
             block(retCode,resultMsg,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (block){
             block(nil,@"验证失败",error);
         }
     }];
}

//token是否存在
+ (void)checkTokenWithBlock:(void (^)(BOOL isExist))block paramDic:(NSDictionary *)paramDic
{
    NSString *urlString = @"auth/token";
    [[AppNetAPIClient sharedClient] GET:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *resultCode = [responseObject objectForKey:kResultCode];
         
         if (![resultCode isEqualToString:kSuccessCode]) {
             block(NO);
             return;
         }
         
         //请求成功
         NSString *reMessage = [responseObject objectForKey:@"message"];
         if (block) {
             if ([reMessage isEqualToString:@"true"]) {
                 block(YES);
             }
             else
             {
                 block(NO);
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (block) {
             block(NO);
         }
     }];
}

@end
