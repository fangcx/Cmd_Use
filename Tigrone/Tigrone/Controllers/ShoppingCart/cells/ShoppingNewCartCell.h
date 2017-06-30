//
//  ShoppingNewCartCell.h
//  Tigrone
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol ShoppingNewCartDelegate <NSObject>

@optional
//选择
-(void)goodsDidSelected:(id)sender cell:(id)obj;

//减数目
- (void)goodsDidMinus:(id)sender cell:(id)obj;

//加数目
- (void)goodsDidAdd:(id)sender cell:(id)obj;

//删除
- (void)goodsDidDeleted:(id)sender cell:(id)obj;

@end

@interface ShoppingNewCartCell : UITableViewCell

@property(nonatomic, assign)id<ShoppingNewCartDelegate>delegate;

@property (nonatomic, strong)GoodsModel *goodsModel;
@property (nonatomic, weak)IBOutlet UIButton *leftBtn;
@property (nonatomic, weak)IBOutlet UIImageView *skuImg;
@property (nonatomic, weak)IBOutlet UILabel *nameLab;
@property (nonatomic, weak)IBOutlet UILabel *desLab;
@property (nonatomic, weak)IBOutlet UILabel *priceLab;
@property (nonatomic, weak)IBOutlet UILabel *numberLab;

@property (nonatomic, weak)IBOutlet UIView *editView;
@property (nonatomic, weak)IBOutlet UIButton *addBtn;
@property (nonatomic, weak)IBOutlet UIButton *minusBtn;
@property (nonatomic, weak)IBOutlet UILabel *totalLab;
@property (nonatomic, weak)IBOutlet UIButton *deleteBtn;

@end
