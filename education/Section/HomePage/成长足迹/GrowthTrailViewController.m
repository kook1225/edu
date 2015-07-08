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
    NSLog(@"123");
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 146;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"journalCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JournalCell" owner:self options:nil] lastObject];
    }
    
    [cell setData];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
