//
//  CoreUtils.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "CoreUtils.h"
#import "AFNetworkReachabilityManager.h"

@implementation CoreUtils

+ (void)openDDLog
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    if (DDFILE_LOG_ON)
    {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 2;
        fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
        
        [DDLog addLogger:fileLogger];
    }
}

+ (void)startMonitorNetwork
{
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];  //开启网络监视器；
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status)
        {
            case AFNetworkReachabilityStatusNotReachable:
            {
                DDLogInfo(@"网络不通");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                DDLogInfo(@"网络通过WIFI连接");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                DDLogInfo(@"网络通过无线连接");
                break;
            }
            default:
                break;
        }
        
        DDLogInfo(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

+ (BOOL)isNetWorkReachable
{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

@end
