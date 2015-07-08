//
//  EDMyPhotoViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyPhotoViewController.h"
#import "SETabBarViewController.h"
#import "EDMyPhotoCell.h"

@interface EDMyPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"相册";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [_tableView registerClass:[EDMyPhotoCell class] forCellReuseIdentifier:@"photo"];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMyPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    [photoCell setIntroductionText:@"测试测试测试测试测试测试测试测试" image:@[@"example1",@"example2"]];
    return photoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
