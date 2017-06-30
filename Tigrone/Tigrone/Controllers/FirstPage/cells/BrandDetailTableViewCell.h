//
//  BrandDetailTableViewCell.h
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelsModel.h"
#import "VolumesModel.h"
#import "YearModel.h"

@interface BrandDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

-(void)setYearModeltWithModel:(YearModel*)model;

-(void)setCarModelsWithModel:(ModelsModel*)model;

-(void)setVolumesModelWithModel:(VolumesModel*)model;



@end
