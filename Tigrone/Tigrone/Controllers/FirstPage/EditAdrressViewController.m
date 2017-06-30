//
//  EditAdrressViewController.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/21.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "EditAdrressViewController.h"
#import "EditAddressCell.h"
#import "FAreaPicker.h"
#import "TigroneRequests.h"

@interface EditAdrressViewController ()<UITableViewDataSource,UITableViewDelegate,EditAddressCellDelegate,FAreaPickerDelegate>
{
    FAreaPicker *_areaPicker;
    
    UITextField *_currentField;
}

@property (nonatomic, weak)IBOutlet UITableView *dataTableView;

@end

@implementation EditAdrressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![NSString isBlankString:self.titleStr]) {
        self.title = _titleStr;
    }
    
    if (!_addressModel) {
        _addressModel = [[AddressModel alloc] init];
    }
}

#pragma mark - uibutton
-(IBAction)saveBtnClip:(id)sender
{
    if ([NSString isBlankString:_addressModel.name]) {
        [MBProgressHUD showHUDAWhile:@"请输入收货人" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if ([NSString isBlankString:_addressModel.phone]) {
        [MBProgressHUD showHUDAWhile:@"请输入联系电话" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (![NSString isPhoneNumber:_addressModel.phone]) {
        [MBProgressHUD showHUDAWhile:@"请输正确的电话" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if ([NSString isBlankString:_addressModel.province] || [NSString isBlankString:_addressModel.city]) {
        [MBProgressHUD showHUDAWhile:@"请选择省市" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if ([NSString isBlankString:_addressModel.detailAddr]) {
        [MBProgressHUD showHUDAWhile:@"请输入详细地址" toView:self.navigationController.view duration:1.0];
        return;
    }
    //save address
    _addressModel.isDefault = NO;
    [self addAddressRequest];
}

#pragma mark - request
- (void)addAddressRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests addNewAddressWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (isSuccess) {
            //添加成功
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"address":[NSString getJsonStringWith:@{@"address":_addressModel.detailAddr,
                                                          @"city":_addressModel.city,
                                                         @"name":_addressModel.name,
                                                          @"phone":_addressModel.phone,
                                                          @"province":_addressModel.province}]}];
}

- (void)updateAddressRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests editAddressWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"address":[NSString getJsonStringWith:@{@"id":_addressModel.addressId,
                                                          @"address":_addressModel.detailAddr,
                                                          @"city":_addressModel.city,
                                                          @"name":_addressModel.name,
                                                          @"phone":_addressModel.phone,
                                                          @"province":_addressModel.province}]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ];
}

#pragma mark - UITableViewDelegate &dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"EditAddressCell";
    EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.delegate = self;
    [cell.rightField resignFirstResponder];
    cell.rightField.tag = indexPath.row;
    cell.rightArrowImg.hidden = YES;
    [cell.rightField setUserInteractionEnabled:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.leftLab setText:@"收货人："];
            cell.rightField.placeholder = @"请输入收货人姓名";
            [cell.rightField setText:_addressModel.name];
        }
            break;
        case 1:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.leftLab setText:@"联系方式："];
            cell.rightField.placeholder = @"请输入联系电话";
            [cell.rightField setKeyboardType:UIKeyboardTypePhonePad];
            [cell.rightField setText:_addressModel.phone];
        }
            break;
        case 2:
        {
            cell.rightArrowImg.hidden = NO;
            [cell.leftLab setText:@"所在省市："];
            [cell.rightField setFrame:CGRectMake(85, 12, kMainScreenWidth - 100 - 13, 19)];
            cell.rightField.placeholder = @"请选择省市";
            [cell.rightField setUserInteractionEnabled:NO];
            [cell.rightField setText:[NSString stringWithFormat:@"%@%@",_addressModel.province,_addressModel.city]];
            
            if ([_addressModel.province isEqualToString:_addressModel.city]) {
                cell.rightField.text = _addressModel.city;
            }
        }
            break;
            
        default:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.leftLab setText:@"详细地址："];
            cell.rightField.placeholder = @"请输入详细地址";
            [cell.rightField setText:_addressModel.detailAddr];
        }
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [_dataTableView reloadData];
        if (_areaPicker == nil) {
            _areaPicker = [[FAreaPicker alloc] initWithFrame:CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight)];
        }
        _areaPicker.delegate = self;
        [self.navigationController.view addSubview:_areaPicker];
        [self.navigationController.view bringSubviewToFront:_areaPicker];
    }
}

#pragma mark - pickerViewDelegate
-(void)changePickerArea:(NSString *)province AndCity:(NSString *)city
{
    if (_addressModel) {
        _addressModel.province = province;
        _addressModel.city = city;
    }
    [_dataTableView reloadData];
}

#pragma mark -ffruitCellDelegate
- (void)rightTextDidChanged:(UITextField *)textField text:(NSString *)text
{
    NSUInteger tag = textField.tag;
    switch (tag) {
        case 0:
        {
            _addressModel.name = text;
        }
            break;
        case 1:
        {
            _addressModel.phone = text;
        }
            break;
            
        default:
        {
            _addressModel.detailAddr = text;
        }
            break;
    }
}

- (void)rightFieldStart:(UITextField *)textField
{
    _currentField = textField;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_currentField) {
        [_currentField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
