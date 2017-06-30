//
//  OrderViewCell.h
//  Tigrone
//
//  Created by 张亮 on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceShopLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;

@end
