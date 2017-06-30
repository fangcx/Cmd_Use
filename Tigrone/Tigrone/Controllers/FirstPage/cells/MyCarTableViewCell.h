//
//  MyCarTableViewCell.h
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/26.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@protocol MyCarTableViewCellDelegate <NSObject>

@optional
-(void)selectMyCarWithIndex:(NSInteger)index;

@end

@interface MyCarTableViewCell : UITableViewCell

@property (assign,nonatomic) id<MyCarTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

-(void)setContentWithCarModelModel:(CarModel*)model withIndex:(NSInteger)index;

@end
