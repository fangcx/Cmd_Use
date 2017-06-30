//
//  ShopCommentModel.h
//  Tigrone
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ShopCommentModel : NSObject

@property (nonatomic, strong)NSString *commentId;       //评论id
@property (nonatomic, strong)NSString *shopId;          //维修店id
@property (nonatomic, strong)NSString *userIcon;        //用户图标
@property (nonatomic, strong)NSString *userName;        //评论用户
@property (nonatomic, strong)NSString *commentTime;     //评论时间
@property (nonatomic, strong)NSString *commentScore;     //总体评分
@property (nonatomic, strong)NSString *serverScore;     //服务评分
@property (nonatomic, strong)NSString *skillScore;      //技能评分
@property (nonatomic, strong)NSString *enviScore;       //环境评分
@property (nonatomic, strong)NSString *commentTitle;    //评论标题
@property (nonatomic, strong)NSString *commentContent;  //评论内容

@end
