//
//  EDPrivateDetailViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPrivateDetailViewController.h"
#import "CheckImageViewController.h"

@interface EDPrivateDetailViewController ()
{
    NSMutableArray *imgArray;
}

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkImg;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation EDPrivateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"私信详情";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@留言",_model.YHM];
    _dateLabel.text = _model.FBSJ;
    
    if (![_model.TPDZ isEqualToString:@""]) {
        imgArray = [NSMutableArray arrayWithArray:[_model.TPDZ componentsSeparatedByString:@","]];
    }
    
    [self drawlayer:_model.FBNR array:imgArray];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawlayer:(NSString *)text array:(NSMutableArray *)array
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
    
    if ([array count] != 0) {
        for (int i=0; i<array.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+95*i, CGRectGetMaxY(_lineView.frame)+10, 75, 75)];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[array objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
            
            imageView.userInteractionEnabled = YES;
            
            [self.view addSubview:imageView];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(checkImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
    }
    
}

- (void)checkImage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    checkImageVC.dataArray = imgArray;
    checkImageVC.page = (int)btn.tag - 400;
    [self.navigationController pushViewController:checkImageVC animated:YES];
}

@end
