//
//  CoreUtils.h
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

#ifdef DEBUG

static const int ddLogLevel = DDLogLevelVerbose;
// A sign of whether open the DDFileLogger
#define DDFILE_LOG_ON 0

#else

static const int ddLogLevel = DDLogLevelError;
// A sign of whether open the DDFileLogger
#define DDFILE_LOG_ON 0

#endif

@interface CoreUtils : NSObject

/**
 Add DDLog to Project
 */
+ (void)openDDLog;

/**
 Start monitor network
 */
+ (void)startMonitorNetwork;

/**
 Whether Network is reachable
 */
+ (BOOL)isNetWorkReachable;

@end
