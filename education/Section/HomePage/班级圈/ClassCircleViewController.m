//
//  ClassCircleViewController.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ClassCircleViewController.h"
#import "SETabBarViewController.h"
#import "ClassCircleCell.h"

@interface ClassCircleViewController () {
    SETabBarViewController *tabBarViewController;
    NSArray *stringArray;
    NSArray *imagesArray;
}

@end

@implementation ClassCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级圈";
    
    stringArray = [NSArray array];
    imagesArray = [NSArray array];
    
    stringArray = @[@"h和和哈哈哈哈哈哈",@"是是是是是是是是是是是是是是是是是呃呃呃呃呃呃呃呃呃是",@"去去去去去去去去去去去去去去去去去去去去去去去去去去去去去去去求去去去去去去去去去去去去去去去去去去去去去去求"];
    
    imagesArray = @[@"1",@"1",@"1"];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
}

#pragma mark - Custom Method
- (void)backBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtn {
    NSLog(@"11");
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stringArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCircleCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassCircleCell" owner:self options:nil] lastObject];
    }
    
    [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row]] image:imagesArray reply:@[@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊a",@"范德萨范德萨范德萨范德萨大叔大叔的"] index:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
