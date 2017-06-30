//
//  AddressCell.h
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressCellDelegate <NSObject>

@optional
- (void)tapEditBtn:(id)sender cell:(id)obj;

@end

@interface AddressCell : UITableViewCell

@property (nonatomic, assign)id<AddressCellDelegate>delegate;
@property (nonatomic, strong)AddressModel *addressModel;
@property (nonatomic, weak)IBOutlet UILabel *nameLab;
@property (nonatomic, weak)IBOutlet UILabel *phoneLab;
@property (nonatomic, weak)IBOutlet UILabel *defalutLab;
@property (nonatomic, weak)IBOutlet UILabel *addressLab;

@end
