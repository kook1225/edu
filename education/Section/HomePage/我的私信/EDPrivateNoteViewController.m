//
//  EDPrivateNoteViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPrivateNoteViewController.h"
#import "SETabBarViewController.h"
#import "EDPrivateNoteCell.h"
#import "EDPrivateNoteSelectedCell.h"
#import "EDPrivateDetailViewController.h"

@interface EDPrivateNoteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *selectedArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPrivateNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的私信";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    selectedArray = [NSMutableArray array];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.row---%ld",(long)indexPath.row);
        for(int i =0;i<selectedArray.count;i++)
        {
            if ([NSNumber numberWithInteger:indexPath.row]  == selectedArray[i]) {
                EDPrivateNoteSelectedCell *selectedCell = [tableView dequeueReusableCellWithIdentifier:@"selected"];
                if (selectedCell == nil) {
                    selectedCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteSelectedCell" owner:self options:nil]lastObject];
                }
                return selectedCell;
            }
            

        }
        EDPrivateNoteCell *nomalCell = [tableView dequeueReusableCellWithIdentifier:@"nomal"];
        if (nomalCell == nil) {
            nomalCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteCell" owner:self options:nil]lastObject];
        }
        return nomalCell;

        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!([selectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]])) {
        [selectedArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    
    EDPrivateDetailViewController *privateDetailVC = [[EDPrivateDetailViewController alloc]init];
    [self.navigationController pushViewController:privateDetailVC animated:YES];
   
    
    [_tableView reloadData];
}

@end
