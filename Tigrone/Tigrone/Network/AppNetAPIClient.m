//
//  AppNetAPIClient.m
//  Damon
//
//  Created by Zhang Gang on 11/3/14.
//  Copyright (c) 2014 Razorfish WH. All rights reserved.
//

#import "AppNetAPIClient.h"

@implementation AppNetAPIClient

static NSString * const AFAppDotNetAPIBaseURLString = @"http://120.55.160.23:8080";

+ (instancetype)sharedClient {
    static AppNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
//        //fix "unacceptable content-type: text/plain" error
//        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //fix "unacceptable content-type: text/html" error
//        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", nil];
    });
    
    return _sharedClient;
}

@end
