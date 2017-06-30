//
//  MyCommentTableViewCell.h
//  Tigrone
//
//  Created by 张亮 on 15/12/29.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface MyCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *repairShopLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet DYRateView *commentStarView;

@end
