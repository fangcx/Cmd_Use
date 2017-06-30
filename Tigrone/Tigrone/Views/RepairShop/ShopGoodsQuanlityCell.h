//
//  ShopGoodsQuanlityCell.h
//  Tigrone
//
//  Created by 张刚 on 15/12/29.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCommentModel.h"

@class DYRateView;
@interface ShopGoodsQuanlityCell : UITableViewCell

@property (nonatomic, strong)ShopCommentModel *model;
@property (weak, nonatomic) IBOutlet DYRateView *commentRateView;
@end
