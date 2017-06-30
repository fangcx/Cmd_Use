//
//  SelectCityViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/22.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectCityCell.h"
#import "TigroneRequests.h"
#import "AreaOperations.h"

@interface SelectCityViewController ()

@property (nonatomic, strong)IBOutlet UITableView *dataTableView;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
}

#pragma mark UITableView&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isHeader) {
        return 2;
    }
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ( self.isHeader) {
        return 30;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isHeader) {
        if (section == 0) {
            return @"当前位置";
        }
        else
        {
            return @"选择城市";
        }
    }
    else
    {
        return @"";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isHeader) {
        if (section == 0) {
            return 1;
        }
        else
        {
            return [_dataArr count];
        }
    }
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityCell"];
    cell.selectedIcon.hidden = YES;
    if (self.isHeader && indexPath.section == 0) {
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([NSString isBlankString:self.localCity]) {
            cell.cityLab.text = @"定位失败";
        }
        else
        {
            cell.cityLab.text = self.localCity;
        }
        
        return cell;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (self.isHeader && indexPath.section == 1) {
        cell.selectedIcon.hidden = NO;
    }
    NSDictionary *item = _dataArr[indexPath.row];
    
    [cell.cityLab setText:item[@"value"]];
    
    return cell;
}

//cell点击事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = _dataArr[indexPath.row];
    if (self.isHeader) {
        if (indexPath.section != 0) {
            UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
            SelectCityViewController *selectVC = [mainBoard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
            selectVC.dataArr = item[@"citys"];
            selectVC.isHeader = NO;
            [self.navigationController pushViewController:selectVC animated:YES];
        }
        else
        {
            if (![NSString isBlankString:self.localCity]) {
                //选中城市
                AreaModel *model = [[AreaModel alloc] init];
                model.areaId = @"1";
                model.areaName = self.localCity;
                [AreaOperations setCurrentCity:model];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        //选中城市
        AreaModel *model = [[AreaModel alloc] init];
        model.areaId = item[@"id"];
        model.areaName = item[@"value"];
        [AreaOperations setCurrentCity:model];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
