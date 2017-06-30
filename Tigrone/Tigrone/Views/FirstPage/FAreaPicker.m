//
//  FAreaPicker.m
//  Fruit
//
//  Created by fangchengxiang on 15/6/3.
//  Copyright (c) 2015年 Fruit. All rights reserved.
//

#import "FAreaPicker.h"
#import "CommonMacro.h"

@implementation FAreaPicker

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
        
        _submit = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(change)];
        
        UIBarButtonItem *_space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, kMainScreenWidth, 44)];
        [toolBar setBarStyle:UIBarStyleDefault];
        
        [toolBar setItems:[NSArray arrayWithObjects:_back,_space,_submit, nil]];
        
        NSString *addressPlist = [[NSBundle mainBundle] pathForResource:@"addressInfo" ofType:@"plist"];
        NSMutableDictionary *plistDic = [[NSMutableDictionary alloc] initWithContentsOfFile:addressPlist];
        
        if (plistDic) {
            _provinces = plistDic[@"provinces"];
        }
        
        _pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0,44, kMainScreenWidth, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        if (CurrentSystemVersion >= 7.0) {
            _pickerView.backgroundColor = [UIColor whiteColor];
            
        }else
        {
            _pickerView.backgroundColor = [UIColor clearColor];
            
        }
        
        [bgView addSubview:toolBar];
        [bgView addSubview:_pickerView];
        
        
        NSUInteger selectedProvinceIndex = [_pickerView selectedRowInComponent:0];
        NSUInteger selectedCityIndex = [_pickerView selectedRowInComponent:1];
        
        NSDictionary *provinceItem = _provinces[selectedProvinceIndex];
        _citys = provinceItem[@"citys"];
        _province = provinceItem[@"value"];
        
        NSDictionary *cityItem = _citys[selectedCityIndex];
        _city = cityItem[@"value"];
    }
    return self;
}

#pragma mark -
#pragma mark 确认按钮
//确认按钮
-(void)change
{
    [self dismiss];
    
    if (!_province || !_city) {
        _province = @"";
        _city = @"";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(changePickerArea:AndCity:)]) {
        [_delegate changePickerArea:_province AndCity:_city];
    }
    
}

#pragma mark -
#pragma mark 取消按钮
-(void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - uipicker DataSource & delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kMainScreenWidth/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // 设置每一个单元格的行宽
    CGFloat width = kMainScreenWidth/3;
    // 设置每一个单元格的行高
    CGFloat height = 40.0f;
    // 新建一个label用于存放在单元格UIView中
    UILabel * singleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    singleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    singleLabel.font = [UIFont systemFontOfSize:16];
    singleLabel.textColor = UIColorFromRGB(0x333333);
    singleLabel.textAlignment = NSTextAlignmentCenter;
    UIView * singleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [singleView addSubview:singleLabel];
    return singleView;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省个数
        return [_provinces count];
    } else{//市区的个数
        return [_citys count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {//选择城市
        NSDictionary *item = _provinces[row];
        return item[@"value"];
    } else{//选择区域
        NSDictionary *item = _citys[row];
        return item[@"value"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (_provinces.count > row) {
            //刷新area
            NSDictionary *item = _provinces[row];
            _citys = item[@"citys"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
                        
            _province = item[@"value"];
            
            if (_citys.count > 0) {
                NSDictionary *cityItem = _citys[0];
                _city = cityItem[@"value"];
            }
        }
    }
    else{
        
        if (_citys.count > row) {
            NSUInteger selectedProvinceIndex = [_pickerView selectedRowInComponent:0];
            NSDictionary *provinceItem = _provinces[selectedProvinceIndex];
            _citys = provinceItem[@"citys"];
            _province = provinceItem[@"value"];
            
            NSDictionary *cityItem = _citys[row];
            _city = cityItem[@"value"];
        }
    }
}

@end
