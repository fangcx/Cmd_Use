//
//  CommentModel.h
//  Tigrone
//
//  Created by 张刚 on 15/12/29.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic, strong)NSString *commentAvatarUrl;//评论者头像
@property(nonatomic, strong)NSString *commenterName;//评论者姓名

@property(nonatomic, strong)NSString *dateString;//评论时间

@property(nonatomic, strong)NSString *techScore;//技术水平评分
@property(nonatomic, strong)NSString *attitudeScore;//态度评分
@property(nonatomic, strong)NSString *noPromoteScore;//0 推销评分
@property(nonatomic, strong)NSString *chargeScore;//收费评分
@property(nonatomic, strong)NSString *environmentScore;//环境评分

@property(nonatomic, strong)NSString *commentString;//评论内容
@end
