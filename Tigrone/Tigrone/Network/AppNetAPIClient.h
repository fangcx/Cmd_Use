//
//  AppNetAPIClient.h
//  Damon
//
//  Created by Zhang Gang on 11/3/14.
//  Copyright (c) 2014 Razorfish WH. All rights reserved.
//

#import "AFNetworking.h"

@interface AppNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
