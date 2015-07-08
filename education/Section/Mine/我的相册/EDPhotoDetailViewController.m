//
//  EDPhotoDetailViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailViewController.h"
#import "EDPhotoDetailCell.h"

@interface EDPhotoDetailViewController ()
{
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    [_tableView registerClass:[EDPhotoDetailCell class] forCellReuseIdentifier:@"photo"];
    
    dataArray = @[@"测试测试测试",@"特色看见俺还是看到哈开始的卡号上课好的卡号SD卡还是看到按客户贷款",@"安顺供电局阿訇是肯定就会卡上的卡号就是电话卡还是肯定回家啊"];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhotoDetailCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    [photoCell setIntroductionText:@"阿斯达时刻记得哈开始的卡号SD卡承诺卡开始就" image:@[@"example1",@"example2"] comment:dataArray];
    return photoCell;
}


@end
