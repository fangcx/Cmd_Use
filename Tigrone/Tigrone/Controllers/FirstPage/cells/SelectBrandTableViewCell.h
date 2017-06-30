//
//  SelectBrandTableViewCell.h
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandsModel.h"

@interface SelectBrandTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLab;

-(void)setContentWithBrandsModelModel:(BrandsModel*)model;

@end
