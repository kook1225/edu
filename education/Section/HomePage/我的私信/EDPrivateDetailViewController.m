//
//  EDPrivateDetailViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPrivateDetailViewController.h"

@interface EDPrivateDetailViewController ()
{
    NSArray *imgArray;
}

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkImg;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation EDPrivateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"私信详情";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    imgArray = @[@"example1",@"example2"];
    
    [self drawlayer:@"阿什顿空间哈开始计划的卡号SD卡还是的空间啊HD声卡户口登记哈肯定哈开始的卡号SD卡好的卡号11" array:imgArray];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawlayer:(NSString *)text array:(NSArray *)array
{
    _containView.layer.borderColor = LINECOLOR.CGColor;
    _containView.layer.borderWidth = 1.0;
    
  
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _noteLabel.attributedText = attributedString;
    _noteLabel.numberOfLines = 0;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH-20-16, 500000);
    
    labelSize = [_noteLabel sizeThatFits:size];
    
  
    _noteLabel.frame = CGRectMake(8, 8,labelSize.width, labelSize.height);
    
    _containView.frame = CGRectMake(10, 40, SCREENWIDTH - 20, CGRectGetMaxY(_noteLabel.frame)+40);
    
    _checkImg.frame = CGRectMake(10, CGRectGetMaxY(_containView.frame)+10, 50, 15);
    
    _lineView.frame = CGRectMake(10, CGRectGetMaxY(_checkImg.frame)+10, SCREENWIDTH-20, 1);
    
    for (int i=0; i<array.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+95*i, CGRectGetMaxY(_lineView.frame)+10, 75, 75)];
        imageView.image = [UIImage imageNamed:array[i]];
        [self.view addSubview:imageView];
    }
    
  
    
}
@end
