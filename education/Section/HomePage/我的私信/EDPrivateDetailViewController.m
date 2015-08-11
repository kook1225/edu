//
//  EDPrivateDetailViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPrivateDetailViewController.h"
#import "CheckImageViewController.h"
#import "EDSendMsgViewController.h"

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
    
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    if([_type isEqualToString:@"收件箱"])
    {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(275, 0, 40, 25);
        [rightBtn setTitle:@"回复" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(replyBtn) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = right;

    }
    
    if ([self.title  isEqual: @"详情"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",_model.XXBT];
        _dateLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame) + 5, 134, 15);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
        _dateLabel.text = _model.FBSJ;
        if (![_model.TPDZ isEqualToString:@""]) {
            imgArray = [NSMutableArray arrayWithArray:[_model.TPDZ componentsSeparatedByString:@","]];
        }
        
        [self drawlayer:_model.FBNR array:imgArray];
    }
    else {
        _nameLabel.text = [NSString stringWithFormat:@"%@留言",_name];
        _dateLabel.text = _date;
        if (![_imagesString isEqualToString:@""])
        {
            imgArray = [NSMutableArray arrayWithArray:[_imagesString componentsSeparatedByString:@","]];

        }
        [self drawlayer:_content array:imgArray];
    }
    

    
    
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)replyBtn
{
    NSLog(@"回复");
    EDSendMsgViewController *sendMsgVC = [[EDSendMsgViewController alloc]init];
    sendMsgVC.type = _jsType;
    sendMsgVC.detailId = _jsid;
    [self.navigationController pushViewController:sendMsgVC animated:YES];
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
    
    _containView.frame = CGRectMake(10, CGRectGetMaxY(_dateLabel.frame) + 10, SCREENWIDTH - 20, CGRectGetMaxY(_noteLabel.frame)+40);
    
    _checkImg.frame = CGRectMake(10, CGRectGetMaxY(_containView.frame)+10, 50, 15);
    
    _lineView.frame = CGRectMake(10, CGRectGetMaxY(_checkImg.frame)+10, SCREENWIDTH-20, 1);
    
    if ([array count] != 0) {
        for (int i=0; i<array.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+95*i, CGRectGetMaxY(_lineView.frame)+10, 75, 75)];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[array objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
            
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
