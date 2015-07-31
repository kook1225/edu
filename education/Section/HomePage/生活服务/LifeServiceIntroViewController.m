//
//  LifeServiceIntroViewController.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LifeServiceIntroViewController.h"
#import "SureOrderViewController.h"
#import "ProductListModel.h"
#import "CheckImageViewController.h"

@interface LifeServiceIntroViewController ()<UIWebViewDelegate> {
    CGFloat scale;
    NSArray *imagesArray;
    ProductListModel *model;
}
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *saledLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LifeServiceIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scale = SCALE;
    
    imagesArray = [NSArray array];
    
    _topImageView.frame = CGRectMake(0, 0, SCREENWIDTH, 213 * scale);
    _introView.frame = CGRectMake(0, CGRectGetMaxY(_topImageView.frame), SCREENWIDTH, _introView.frame.size.height);
    _webView.frame = CGRectMake(0, CGRectGetMaxY(_introView.frame), SCREENWIDTH, _webView.frame.size.height);
    
    
    [self proIntro];
    
    
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
    SureOrderViewController *sureOrderVC = [[SureOrderViewController alloc] init];
    sureOrderVC.model = model;
    [self.navigationController pushViewController:sureOrderVC animated:YES];
}

- (IBAction)imageTap:(id)sender {
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    checkImageVC.dataArray = imagesArray;
    checkImageVC.page = 0;
    [self.navigationController pushViewController:checkImageVC animated:YES];
}


- (void)proIntro {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"id":_proId
                  };
 
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Product",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 model = [[ProductListModel alloc] initWithDictionary:responseObject[@"data"] error:&err];
                 
                 imagesArray = [model.img componentsSeparatedByString:@","];
                 
                 NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,imagesArray[0]];
                 NSURL *url = [NSURL URLWithString:urlStr];
                 [_topImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
                 
                 UIImageView *numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * scale, 175 * scale, 50, 30)];
                 [numImageView setImage:[UIImage imageNamed:@"blackNav"]];
                 numImageView.layer.cornerRadius = 5.0f;
                 numImageView.clipsToBounds = YES;
                 [_topImageView addSubview:numImageView];
                 
                 UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
                 numLabel.textColor = [UIColor whiteColor];
                 numLabel.textAlignment = NSTextAlignmentCenter;
                 numLabel.font = [UIFont systemFontOfSize:14];
                 numLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)[imagesArray count]];
                 [numImageView addSubview:numLabel];
                 
                 
                 _titleLabel.text = model.name;
                 
                 
                 NSString *path_1 = [[NSBundle mainBundle] pathForResource:@"details" ofType:@"html"];
                 NSString *string_1 = [[NSString alloc]initWithContentsOfFile:path_1 encoding:NSUTF8StringEncoding error:nil]; //设置内容
                 NSString *newContent_1 = [string_1 stringByReplacingOccurrencesOfString:@"${content}" withString:model.intro];
                 [_webView loadHTMLString:newContent_1 baseURL:[[NSBundle mainBundle] bundleURL]];
                 _webView.scrollView.scrollEnabled = NO;
                 
                 
                 _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 30, 20)];
                 
                 _oldPriceLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
                 _oldPriceLabel.font = [UIFont systemFontOfSize:12];
                 
                 NSString *oldPrice = [NSString stringWithFormat:@"¥%@",model.market_price];
                 NSUInteger length=[oldPrice length];
                 
                 NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:oldPrice];
                 [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)range:NSMakeRange(0,length)];
                 [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000]
                               range:NSMakeRange(2, length-2)];
                 
                 //[_oldPriceLabel sizeToFit];
                 [_oldPriceLabel setAttributedText:attri];
                 [_oldPriceLabel sizeToFit];
                 [_introView addSubview:_oldPriceLabel];
                 
                 
                 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_oldPriceLabel.frame) + 5, 30, 10, 20)];
                 label.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
                 label.font = [UIFont boldSystemFontOfSize:14];
                 label.text = @"¥";
                 [_introView addSubview:label];
                 
                 _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 29, 100, 20)];
                 _priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
                 _priceLabel.font = [UIFont boldSystemFontOfSize:20];
                 _priceLabel.text = model.sale_price;
                 [_introView addSubview:_priceLabel];
                 
                 
                 _saledLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 110, 30, 100, 20)];
                 _saledLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
                 _saledLabel.font = [UIFont systemFontOfSize:12];
                 _saledLabel.textAlignment = NSTextAlignmentRight;
                 NSString *saledStr = [NSString stringWithFormat:@"已销售%@%@",model.salecount,model.unit];
                 //NSUInteger length2=[oldPrice length];
                 
                 NSMutableAttributedString *attri2 =[[NSMutableAttributedString alloc]initWithString:saledStr];
                 [attri2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45.0/255.0 alpha:1.000]
                                range:NSMakeRange(3, [model.salecount length])];
                 [_saledLabel setAttributedText:attri2];
                 [_introView addSubview:_saledLabel];
                 
                 
                 _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_introView.frame) + _webView.frame.size.height);
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [HUD hide:YES];
             if(error.code == -1001)
             {
                 SHOW_ALERT(@"提示", @"网络请求超时");
             }else if (error.code == -1009)
             {
                 SHOW_ALERT(@"提示", @"网络连接已断开");
             }
         }];

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
