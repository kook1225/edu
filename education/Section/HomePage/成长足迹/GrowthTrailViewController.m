//
//  GrowthTrailViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "GrowthTrailViewController.h"
#import "SETabBarViewController.h"
#import "JournalCell.h"
#import "EDGrowDetailViewController.h"
#import "EvaluteAndEncourageViewController.h"

@interface GrowthTrailViewController () {
    SETabBarViewController *tabBarViewController;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GrowthTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长足迹";
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发表" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtn {
    EDGrowDetailViewController *growDetailVC = [[EDGrowDetailViewController alloc]init];
    [self.navigationController pushViewController:growDetailVC animated:YES];

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluteAndEncourageViewController *evaluteAndEncourageVC = [[EvaluteAndEncourageViewController alloc] init];
    [self.navigationController pushViewController:evaluteAndEncourageVC animated:YES];
  
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"journalCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JournalCell" owner:self options:nil] lastObject];
    }
    
    if (indexPath.row <= 2) {
        [cell setData:1];
    }
    else {
        [cell setData:2];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
