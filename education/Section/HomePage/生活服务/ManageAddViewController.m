//
//  ManageAddViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ManageAddViewController.h"
#import "SelectAddCell.h"
#import "AddReceiveAddressViewController.h"

@interface ManageAddViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;

@end

@implementation ManageAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    
    _addAddressBtn.layer.cornerRadius = 5.0f;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtn:(id)sender {
    AddReceiveAddressViewController *addReceiveAddressVC = [[AddReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:addReceiveAddressVC animated:YES];
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectAddCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddCell" owner:self options:nil] lastObject];
    }
    
    if (_checkRow == indexPath.row) {
        [cell setData];
    }

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
