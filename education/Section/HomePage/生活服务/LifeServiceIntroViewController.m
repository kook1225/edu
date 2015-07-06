//
//  LifeServiceIntroViewController.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LifeServiceIntroViewController.h"

@interface LifeServiceIntroViewController ()<UIWebViewDelegate> {
    CGFloat scale;
}
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *saledLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

@implementation LifeServiceIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scale = SCALE;
    
    _topImageView.frame = CGRectMake(0, 0, SCREENWIDTH, 213 * scale);
    _introView.frame = CGRectMake(0, CGRectGetMaxY(_topImageView.frame), SCREENWIDTH, _introView.frame.size.height);
    _webView.frame = CGRectMake(0, CGRectGetMaxY(_introView.frame), SCREENWIDTH, _webView.frame.size.height);
    
    _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 30, 20)];
    
    _oldPriceLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
    _oldPriceLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *oldPrice = @"¥280";
    NSUInteger length=[oldPrice length];
    
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)range:NSMakeRange(0,length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000]
                  range:NSMakeRange(2, length-2)];
    
    //[_oldPriceLabel sizeToFit];
    [_oldPriceLabel setAttributedText:attri];
    [_introView addSubview:_oldPriceLabel];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_oldPriceLabel.frame) + 5, 30, 10, 20)];
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = @"¥";
    [_introView addSubview:label];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 29, 100, 20)];
    _priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    _priceLabel.font = [UIFont boldSystemFontOfSize:20];
    _priceLabel.text = @"200";
    [_introView addSubview:_priceLabel];
    
    
    _saledLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 110, 30, 100, 20)];
    _saledLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
    _saledLabel.font = [UIFont systemFontOfSize:12];
    _saledLabel.textAlignment = NSTextAlignmentRight;
    NSString *saledStr = @"已销售30笔";
    //NSUInteger length2=[oldPrice length];
    
    NSMutableAttributedString *attri2 =[[NSMutableAttributedString alloc]initWithString:saledStr];
    [attri2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45.0/255.0 alpha:1.000]
                   range:NSMakeRange(3, 2)];
    [_saledLabel setAttributedText:attri2];
    [_introView addSubview:_saledLabel];
    
    
    _buyBtn.frame = CGRectMake((SCREENWIDTH - 118) / 2.0, 7, 118, 36);
    _buyBtn.layer.cornerRadius = 5.0f;
    _buyBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:124.0/255.0f blue:6.0/255.0f alpha:1.000];
    
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 800);
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

#pragma mark － Custom Method
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buyBtn:(id)sender {
    NSLog(@"1231231");
}

#pragma UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#EFEFEF'"];
    
    
    float height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    NSLog(@"remark高度是---%f",height);
    [_webView setFrame:CGRectMake(0, 304, SCREENWIDTH, height+10)];
    /*
    [_commentView setFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame), 320, 42)];
    if([UIScreen mainScreen].bounds.size.height ==480)
    {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_commentView.frame)+150);
    }else
    {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_commentView.frame)+120);
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
