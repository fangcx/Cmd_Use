//
//  BrandDetailTableViewCell.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BrandDetailTableViewCell.h"
#import "CarModel.h"

@implementation BrandDetailTableViewCell

-(void)setYearModeltWithModel:(YearModel*)model
{
    _nameLab.text = model.name;
}

-(void)setCarModelsWithModel:(ModelsModel*)model
{
    _nameLab.text = model.name;
}

-(void)setVolumesModelWithModel:(VolumesModel*)model
{
    _nameLab.text = model.name;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
