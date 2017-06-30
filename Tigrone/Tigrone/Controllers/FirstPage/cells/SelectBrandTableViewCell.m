//
//  SelectBrandTableViewCell.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SelectBrandTableViewCell.h"
#import "UIImageView+Icon.h"

@implementation SelectBrandTableViewCell

-(void)setContentWithBrandsModelModel:(BrandsModel*)model
{
    [_carLogoImageView setCarLogoWithUrlSting:model.icon placeholderImage:[UIImage imageNamed:@"main_defaultCarIcon"]];
    _carNameLab.text = model.name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
