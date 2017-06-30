//
//  AddressListViewController.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/21.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "AddressListViewController.h"
#import "EditAdrressViewController.h"
#import "AddressModel.h"
#import "AddressCell.h"
#import "TigroneRequests.h"

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate,AddressCellDelegate>

@property (nonatomic, strong)IBOutlet UITableView *dataTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)NSIndexPath *selectIndex;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收货地址";
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAddressListRequest];
}

#pragma mark - request
//获取地址列表
- (void)getAddressListRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getAddressListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (!errorStr) {
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:resultArr];
            [_dataTableView reloadData];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,@"token":Token}];
}

//删除地址
- (void)deleteAddressRequest
{
    AddressModel *model = _dataArr[_selectIndex.row];
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests deleteAddressWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (isSuccess) {
            [MBProgressHUD showHUDAWhile:@"删除成功" toView:self.navigationController.view duration:1];
            if (_selectIndex) {
                [_dataArr removeObject:_dataArr[_selectIndex.row]];
                [_dataTableView reloadData];
            }
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"address":[NSString getJsonStringWith:@{@"id":model.addressId}]}];
}

//设置常用地址
- (void)setDefaultAddressRequest:(AddressModel *)model
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests setDefaultAddressWithBlock:^(NSString *errorStr, BOOL isSuccess) {
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
                 @"address":[NSString getJsonStringWith:@{@"id":model.addressId}]}];
}

#pragma mark - uibutton
- (IBAction)addAddrBtnClip:(id)sender
{
    //添加地址
    UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    EditAdrressViewController *editVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"EditAdrressViewController"];
    editVc.titleStr = @"新建收货地址";
    [self.navigationController pushViewController:editVc animated:YES];
}


#pragma mark - UITableViewDelegate &dataSource
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
    return 80;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"AddressCell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.delegate = self;
    
    cell.addressModel = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self setDefaultAddressRequest:_dataArr[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//修改删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)//删除单元格
    {
        self.selectIndex = indexPath;
        [self deleteAddressRequest];
    }
}

#pragma mark - cellDelegate
- (void)tapEditBtn:(id)sender cell:(id)obj
{
    //编辑收货地址
    AddressCell *cell = (AddressCell *)obj;
    UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    EditAdrressViewController *editVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"EditAdrressViewController"];
    editVc.titleStr = @"编辑收货地址";
    editVc.addressModel = cell.addressModel;
    [self.navigationController pushViewController:editVc animated:YES];
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
