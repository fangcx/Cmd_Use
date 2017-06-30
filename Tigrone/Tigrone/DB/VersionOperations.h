//
//  VersionOperations.h
//  FMDB Test
//
//  Created by 张刚 on 15/12/17.
//  Copyright © 2015年 张刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionOperations : NSObject

//查询当前数据库版本号
+ (NSString *)getDBVersion;

//设置当前数据库版本号
+ (BOOL)setDBVersion:(NSString *)versionString;
@end
