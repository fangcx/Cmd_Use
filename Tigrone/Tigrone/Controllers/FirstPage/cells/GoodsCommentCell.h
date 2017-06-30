//
//  GoodsCommentCell.h
//  Tigrone
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface GoodsCommentCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UILabel *nameLab;
@property (nonatomic, strong)IBOutlet DYRateView *starView;
@property (nonatomic, strong)IBOutlet UILabel *commentContent;

@end
