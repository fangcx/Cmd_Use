//
//  GlobalData.m
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import "GlobalData.h"
#import "DBManager.h"
#import "AreaOperations.h"

@implementation GlobalData

static GlobalData *instance = nil;
static dispatch_once_t onceToken;

+ (GlobalData*)shareInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[GlobalData alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _userId   = @"";
        _phoneNum = @"";
        _token    = @"";
        _isLogin = NO;
    }
    return self;
}

- (void)setUserId:(NSString *)userId
{
    if (!userId) {
        return;
    }
    _userId = userId;
    
    [DBManager initDBSettings];
    
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"userId"];
}

- (void)setPhoneNum:(NSString *)phoneNum
{
    if (!phoneNum) {
        return;
    }
    _phoneNum = phoneNum;
    [[NSUserDefaults standardUserDefaults] setObject:_phoneNum forKey:@"phoneNum"];
}

- (void)setToken:(NSString *)token
{
    if (!token) {
        return;
    }
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:@"userToken"];
}

@end
