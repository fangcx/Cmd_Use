//
//  UnfinishOrderTableViewCell.h
//  Tigrone
//
//  Created by 张亮 on 15/12/26.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnfinishOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *unfinishOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@end
