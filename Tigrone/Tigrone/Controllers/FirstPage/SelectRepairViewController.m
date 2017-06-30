//
//  SelectRepairViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SelectRepairViewController.h"
#import "RepairShopCell.h"
#import "GlobalData.h"
#import "UIImageView+WebCache.h"
#import "NSString+Tigrone.h"
#import "TigroneRequests.h"

@interface SelectRepairViewController ()
{
    NSIndexPath *currentIndex;
}

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)IBOutlet UITableView *tableView;

@end

@implementation SelectRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择维修店";
    [self addNaviBtn];
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    if ([GlobalData shareInstance].repairShops) {
        [_dataArr addObjectsFromArray:[GlobalData shareInstance].repairShops];
    }
}

- (void)addNaviBtn
{
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClip) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
}

#pragma mark - button
- (void)sureBtnClip
{
    if (!_selectModel) {
        [MBProgressHUD showHUDAWhile:@"请选择维修店" toView:self.navigationController.view duration:1];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRepairShop:)]) {
        [_delegate didSelectRepairShop:_selectModel];
    }
    
    [self changeShopRequest:_selectModel.shopId];
}

#pragma mark UITableView&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairShopCell"];
    
    RepairShopModel *model = _dataArr[indexPath.row];
    [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:model.shopIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    [cell.nameLab setText:model.shopName];
    cell.starView.padding = 5;
    cell.starView.alignment = RateViewAlignmentLeft;
    cell.starView.editable = NO;
    [cell.starView setRate:[model.totalScore floatValue]];
    [cell.commentNumLab setText:[NSString stringWithFormat:@"(%@条)",model.commentNum]];
    [cell.addressLab setText:[NSString stringWithFormat:@"%@%@%@",model.shopCity,model.shopCounty,model.shopAddr]];
    
    if (_selectModel && [_selectModel.shopId isEqualToString:model.shopId]) {
        cell.selectImg.image = IMAGE(@"select_repair_on");
        currentIndex = indexPath;
    }
    else
    {
        cell.selectImg.image = IMAGE(@"select_repair_off");
    }
    
    return cell;
}

//cell点击事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (currentIndex) {
        if (indexPath.row == currentIndex.row) {
            return;
        }
        RepairShopCell *oldCell = [tableView cellForRowAtIndexPath:currentIndex];
        [oldCell.selectImg setImage:IMAGE(@"select_repair_off")];
    }
    
    RepairShopCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    [newCell.selectImg setImage:IMAGE(@"select_repair_on")];
    currentIndex = indexPath;
    
    _selectModel = _dataArr[indexPath.row];
}

#pragma mark - request
- (void)changeShopRequest:(NSString *)shopId
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests setUserDefaultShopWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"shopId":shopId}];
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
