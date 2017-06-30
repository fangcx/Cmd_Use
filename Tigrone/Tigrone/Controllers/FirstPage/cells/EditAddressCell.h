//
//  EditAddressCell.h
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditAddressCellDelegate <NSObject>

@optional
- (void)rightFieldStart:(UITextField *)textField;
- (void)rightTextDidChanged:(UITextField *)textField text:(NSString *)text;

@end

@interface EditAddressCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign)id<EditAddressCellDelegate>delegate;
@property (nonatomic, weak)IBOutlet UILabel *leftLab;
@property (nonatomic, weak)IBOutlet UITextField *rightField;
@property (nonatomic, weak)IBOutlet UIImageView *rightArrowImg;

@end
