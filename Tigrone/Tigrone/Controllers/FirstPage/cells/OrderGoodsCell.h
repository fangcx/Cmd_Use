//
//  OrderGoodsCell.h
//  Tigrone
//
//  Created by Mac on 16/6/29.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGoodsCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UIImageView *skuImg;
@property (nonatomic, weak)IBOutlet UILabel *nameLab;
@property (nonatomic, weak)IBOutlet UILabel *priceLab;
@property (nonatomic, weak)IBOutlet UILabel *numberLab;

@end
