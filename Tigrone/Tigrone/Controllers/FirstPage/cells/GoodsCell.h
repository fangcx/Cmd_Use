//
//  GoodsCell.h
//  Tigrone
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface GoodsCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UIImageView *skuIcon;
@property (nonatomic, weak)IBOutlet UILabel *nameLab;
@property (nonatomic, weak)IBOutlet DYRateView *starView;
@property (nonatomic, weak)IBOutlet UILabel *commentNumLab;
@property (nonatomic, weak)IBOutlet UILabel *priceLab;

@end
