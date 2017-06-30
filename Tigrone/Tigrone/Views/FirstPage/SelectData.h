//
//  SelectData.h
//  IOS-IM
//
//  Created by fangchengxiang on 15/6/3.
//  Copyright (c) 2015年 Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonMacro.h"

@protocol SelectDataDelegate <NSObject>

- (void)changeDate:(NSString *)date;
// -(void)dissmissPicker;

@end

@interface SelectData : UIView
{
    UIDatePicker    *_datePicker;
    UIBarButtonItem *_back;
    UIBarButtonItem *_submit;
    NSString        *_date;
}
@property(nonatomic, strong)  UIDatePicker              *_datePicker;
@property(nonatomic, strong)  UIBarButtonItem           *_back;
@property(nonatomic, strong)  UIBarButtonItem           *_submit;
@property(nonatomic, assign)  id <SelectDataDelegate>   delegate;

- (void)change;
- (void)dismiss;
@end