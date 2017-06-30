//
//  FAreaPicker.h
//  Fruit
//
//  Created by fangchengxiang on 15/6/3.
//  Copyright (c) 2015年 Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FAreaPickerDelegate <NSObject>

@optional
-(void)changePickerArea:(NSString *)province AndCity:(NSString *)city;

@end

@interface FAreaPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_province;
    NSString *_city;
}

@property(nonatomic,assign)  id<FAreaPickerDelegate> delegate;
@property(nonatomic,strong)  UIPickerView *pickerView;

@property (nonatomic, strong)NSArray *provinces;//城市的数组
@property (nonatomic, strong)NSArray *citys;//城市的数组

@property(nonatomic,strong)  UIBarButtonItem *back;
@property(nonatomic,strong)  UIBarButtonItem *submit;

-(void)change;
-(void)dismiss;

@end
