//
//  EDMyOrderViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyOrderViewController.h"
#import "SETabBarViewController.h"
#import "EDMyOrderCell.h"
#import "EDOrderHeadCell.h"
#import "EDOrderBottomCell.h"
#import "EDOrderDetailViewController.h"

#define LINEWIDTH SCREENWIDTH/4
@interface EDMyOrderViewController ()
{
    SETabBarViewController *tabBarView;
    UIView *lineView;
    NSArray *dataArray;
    
}

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EDMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资料";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    lineView.frame = CGRectMake(0, 43, LINEWIDTH, 2);
    [_headView addSubview:lineView];
    
    dataArray = @[@"1",@"2"];
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 订单类型
- (IBAction)typeBtnFunction:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[_headView viewWithTag:i+400];
        if(i != button.tag-400)
        {
            [btn setSelected:NO];
        }
        
    }
    switch (button.tag) {
        case 400:
            lineView.frame = CGRectMake(0, 43, LINEWIDTH, 2);
            break;
        case 401:
            lineView.frame = CGRectMake(LINEWIDTH, 43, LINEWIDTH, 2);
            break;
        case 402:
            lineView.frame = CGRectMake(2*LINEWIDTH, 43, LINEWIDTH, 2);
            break;
        case 403:
            lineView.frame = CGRectMake(3*LINEWIDTH, 43, LINEWIDTH, 2);
            break;
            
        default:
            break;
    }
}

#pragma mark tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 33;
    }else if(indexPath.row <=dataArray.count)
    {
        return 95;
    }else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row ==0) {
        EDOrderHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"orderHead"];
        if (headCell == nil) {
            headCell = [[[NSBundle mainBundle]loadNibNamed:@"EDOrderHeadCell" owner:self options:nil]lastObject];
        }
        return headCell;
    }else if(indexPath.row <=dataArray.count)
    {
        EDMyOrderCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"orderContent"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDMyOrderCell" owner:self options:nil]lastObject];
        }
        return contentCell;
    }else
    {
        EDOrderBottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"orderBottom"];
        if (bottomCell == nil) {
            bottomCell = [[[NSBundle mainBundle]loadNibNamed:@"EDOrderBottomCell" owner:self options:nil]lastObject];
        }
        return bottomCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.row <=dataArray.count)
    {
        EDOrderDetailViewController *orderDetaiVC = [[EDOrderDetailViewController alloc]init];
        orderDetaiVC.type = @"3";
        [self.navigationController pushViewController:orderDetaiVC animated:YES];
    }
}


@end
