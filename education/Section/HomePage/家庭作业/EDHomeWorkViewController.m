//
//  EDHomeWorkViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDHomeWorkViewController.h"
#import "SETabBarViewController.h"

@interface EDHomeWorkViewController ()
{
    SETabBarViewController *tabBarView;
    CGFloat TAB_WITHDE;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateView;

@end

@implementation EDHomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭作业";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"homeWork"];
    
    CGFloat slide_x= 0;
    CGFloat slide_y = 0;
     TAB_WITHDE = 0;
    CGFloat TAB_HEIGHT = 0;
    if (SCREENHEIGHT == 480)
    {
        slide_x = 68;
        slide_y = 160;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 144;
    }else if (SCREENHEIGHT == 568)
    {
        slide_x = 68;
        slide_y = 200;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 170;
    }else if (SCREENHEIGHT == 667)
    {
        slide_x = 80;
        slide_y = 240;
        TAB_WITHDE = 213;
        TAB_HEIGHT = 186;
    }else
    {
        slide_x = 90;
        slide_y = 270;
        TAB_WITHDE = 230;
        TAB_HEIGHT = 210;
    }
    
    
    _tableView.frame = CGRectMake(slide_x, slide_y, TAB_WITHDE, TAB_HEIGHT);
    _dateView.layer.cornerRadius = 6.0f;
    _dateView.layer.borderWidth = 0.5f;
    _dateView.layer.borderColor = [UIColor colorWithRed:109/255.0f green:114/255.0f blue:122/255.0f alpha:1.0].CGColor;

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
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeWork"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *homeWork = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, TAB_WITHDE-20, 40)];
    homeWork.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    homeWork.font = [UIFont systemFontOfSize:12.0];
    NSString *text = @"阿卡时间的空间啊哈SD卡京哈抠脚大汉控件1";
    homeWork.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    homeWork.attributedText = attributedString;
    [cell addSubview:homeWork];
    
    
    
    return cell;
}



@end
