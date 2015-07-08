//
//  EDGradeDetailViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGradeDetailViewController.h"

@interface EDGradeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EDGradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息详情";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
   
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"score"];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"score"];
    UILabel *subject = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 20)];
    subject.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    subject.font = [UIFont systemFontOfSize:14.0];
    subject.text = @"语文";
    [scoreCell addSubview:subject];
    
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 50, 20)];
    score.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    score.font = [UIFont systemFontOfSize:14.0];
    score.text = @"98";
    [scoreCell addSubview:score];
    
    return scoreCell;
}



@end
