//
//  EDPhysicalDetailViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhysicalDetailViewController.h"
#import "EDPhysicalDetailHeadCell.h"
#import "EDPhysicalContentCell.h"

@interface EDPhysicalDetailViewController ()
{
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPhysicalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    dataArray = @[@"1",@"2",@"3",@"4"];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 128;
    }else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row ==0) {
        EDPhysicalDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        if (headCell == nil) {
            headCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPhysicalDetailHeadCell" owner:self options:nil]lastObject];
        }
        return headCell;
    }else
    {
        EDPhysicalContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPhysicalContentCell" owner:self options:nil]lastObject];
        }
        return contentCell;
        
    }
    
}

@end
