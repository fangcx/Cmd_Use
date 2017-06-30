//
//  ShopTableViewCell.h
//  Tigrone
//
//  Created by weili.wu on 15/12/23.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceShopTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceShopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;


@end
