//
//  EDGradeDetailViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGradeDetailViewController.h"
#import "MUScoreListModel.h"

@interface EDGradeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation EDGradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息详情";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
   
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"score"];
    
    CGFloat slide_x= 0;
    CGFloat slide_y = 0;
    CGFloat TAB_WITHDE = 0;
    CGFloat TAB_HEIGHT = 0;
    if (SCREENHEIGHT == 480)
    {
        slide_x = 68;
        slide_y = 160;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 124;
    }else if (SCREENHEIGHT == 568)
    {
        slide_x = 68;
        slide_y = 200;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 156;
    }else if (SCREENHEIGHT == 667)
    {
        slide_x = 80;
        slide_y = 240;
        TAB_WITHDE = 213;
        TAB_HEIGHT = 186;
    }else
    {
        slide_x = 120;
        slide_y = 270;
        TAB_WITHDE = 200;
        TAB_HEIGHT = 210;
    }


    _tableView.frame = CGRectMake(slide_x, slide_y, TAB_WITHDE, TAB_HEIGHT);
    
    
    _titleLabel.text = _titleString;
    _name.text = [NSString stringWithFormat:@"学生姓名: %@",[SEUtils getUserInfo].UserDetail.studentInfo.XSXM];
    
    NSLog(@"array--%@",_dataArray);
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"score"];
    UILabel *subject = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 20)];
    subject.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    subject.font = [UIFont systemFontOfSize:14.0];
    subject.text = _dataArray[indexPath.row][@"KUMC"];
    [scoreCell addSubview:subject];
    
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 50, 20)];
    score.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    score.font = [UIFont systemFontOfSize:14.0];
    score.text = _dataArray[indexPath.row][@"scoreObject"][@"FSDD"];
    [scoreCell addSubview:score];
    
    return scoreCell;
}



@end
