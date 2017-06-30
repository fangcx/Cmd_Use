//
//  GoodsCommentModel.h
//  Tigrone
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCommentModel : NSObject

@property (nonatomic, strong)NSString *commentId;
@property (nonatomic, strong)NSString *skuId;
@property (nonatomic, strong)NSString *commentName;
@property (nonatomic, strong)NSString *commentContent;
@property (nonatomic, strong)NSString *commentScore;

@end
