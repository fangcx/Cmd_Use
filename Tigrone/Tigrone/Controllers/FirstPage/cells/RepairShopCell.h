//
//  RepairShopCell.h
//  Tigrone
//
//  Created by Mac on 15/12/24.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface RepairShopCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UIImageView *shopIcon;
@property (nonatomic, strong)IBOutlet UILabel *nameLab;
@property (nonatomic, strong)IBOutlet DYRateView *starView;
@property (nonatomic, strong)IBOutlet UILabel *commentNumLab;
@property (nonatomic, strong)IBOutlet UILabel *addressLab;
@property (nonatomic, strong)IBOutlet UILabel *distanceLab;
@property (nonatomic, strong)IBOutlet UILabel *unitLab;

@property (nonatomic, strong)IBOutlet UIImageView *selectImg;

@end
