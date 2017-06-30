//
//  SelectData.m
//  IOS-IM
//
//  Created by fangchengxiang on 15/6/3.
//  Copyright (c) 2015年 Fruit. All rights reserved.
//

#import "SelectData.h"

@implementation SelectData
@synthesize _datePicker;
@synthesize _back;
@synthesize _submit;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 - 44, kMainScreenWidth, 216 + 44)];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
        _back = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(dismiss)];
        
        _submit = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(change)];
        
        UIBarButtonItem *_space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, kMainScreenWidth, 44)];
        [toolBar setBarStyle:UIBarStyleDefault];
        
        [toolBar setItems:[NSArray arrayWithObjects:_back,_space,_submit, nil]];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0,44, kMainScreenWidth, 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        if (CurrentSystemVersion >= 7.0)
        {
            _datePicker.backgroundColor = [UIColor whiteColor];
        }else
        {
            _datePicker.backgroundColor = [UIColor clearColor];
        }
        
        [bgView addSubview:toolBar];
        [bgView addSubview:_datePicker];
        
    }
    return self;
}
#pragma mark 确认按钮
//确认按钮
-(void)change
{
    [self dismiss];
    
    NSDate* pickDate = [_datePicker date];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    _date = [NSString stringWithFormat:@"%@",[date stringFromDate:pickDate]];
    
    if (delegate && [delegate respondsToSelector:@selector(changeDate:)])
    {
        [delegate changeDate:_date];
    }
}
#pragma mark 取消按钮
-(void)dismiss
{
    [self removeFromSuperview];
}
@end
