//
//  SureOrderViewController.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SureOrderViewController.h"
#import "SelectAddViewController.h"
#import "SelectPayViewController.h"
#import "ShipAddListModel.h"

@interface SureOrderViewController ()<SelectAddViewControllerDelegate> {
    int num;
    NSString *checkId;
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIView *topView1;
@property (weak, nonatomic) IBOutlet UIView *topView2;
@property (weak, nonatomic) IBOutlet UILabel *recevieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;



@end

@implementation SureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    num = 1;
    
    checkId = @"";
    
    dataArray = [NSArray array];
    
    [self addList];
    
    
    _proName.text = _model.name;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,_model.samll_img];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(112, 35, 10, 20)];
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.text = @"¥";
    [_introView addSubview:label];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 33, 30, 20)];
    _priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    _priceLabel.font = [UIFont boldSystemFontOfSize:18];
    _priceLabel.text = _model.sale_price;
    [_priceLabel sizeToFit];
    [_introView addSubview:_priceLabel];
    
    
    _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 5, 37, 30, 20)];
    
    _oldPriceLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
    _oldPriceLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *oldPrice = [NSString stringWithFormat:@"¥%@",_model.market_price];
    NSUInteger length=[oldPrice length];
    
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)range:NSMakeRange(0,length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000]
                  range:NSMakeRange(2, length-2)];
    
    [_oldPriceLabel setAttributedText:attri];
    [_oldPriceLabel sizeToFit];
    [_introView addSubview:_oldPriceLabel];
    
    
    _totalPrice.text = _priceLabel.text;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addList {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[[SEUtils getUserInfo] TokenInfo] access_token];
    NSString *yhm = [[[[SEUtils getUserInfo] UserDetail] userinfo] YHM];
    
    NSLog(@"token:%@",token);
    NSLog(@"yhm:%@",yhm);
    
    NSString *code = [SEUtils encryptUseDES:[[[SEUtils getUserInfo] TokenInfo] access_token] key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    
    NSLog(@"code:%@",code);
    
    //NSString *text = [SEUtils decryptUseDES:code key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    //NSLog(@"text:%@",text);
    
    
    
    
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"code":code};
    

    
    NSString *urlStr = [NSString stringWithFormat:@"%@ShipAddress",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 if (responseObject[@"data"] == [NSNull null]) {
                     _topView1.hidden = YES;
                     _topView2.hidden = NO;
                 }
                 else {
                     dataArray = [ShipAddListModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
            
                     _topView1.hidden = NO;
                     _topView2.hidden = YES;
                     
                     if (![checkId  isEqual: @""]) {
                         for (int i = 0; i < [dataArray count]; i++) {
                             if ([[[dataArray objectAtIndex:i] id] isEqualToString:checkId]) {
                                 _recevieNameLabel.text = [dataArray[i] contact];
                                 _telLabel.text = [dataArray[i] tel];
                                 
                                 _addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dataArray[i] province],[dataArray[i] city],[dataArray[i] district],[dataArray[i] address]];
                                 _addLabel.numberOfLines = 2;
                                 [_addLabel sizeToFit];
                             }
                         }
                     }
                     else {
                         _recevieNameLabel.text = [dataArray[0] contact];
                         _telLabel.text = [dataArray[0] tel];
                         
                         _addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dataArray[0] province],[dataArray[0] city],[dataArray[0] district],[dataArray[0] address]];
                         _addLabel.numberOfLines = 2;
                         [_addLabel sizeToFit];
                     }
                     
                 }
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

- (IBAction)reduceBtn:(id)sender {
    if ([_numLabel.text intValue] > 1) {
        num--;
        _numLabel.text = [NSString stringWithFormat:@"%d",num];
        _goodsNumLabel.text = [NSString stringWithFormat:@"x %d",num];
        _totalPrice.text = [NSString stringWithFormat:@"%d",[_priceLabel.text intValue] * num];
    }
}
- (IBAction)addBtn:(id)sender {
    if ([_numLabel.text intValue] < 99) {
        num++;
        _numLabel.text = [NSString stringWithFormat:@"%d",num];
        _goodsNumLabel.text = [NSString stringWithFormat:@"x %d",num];
        _totalPrice.text = [NSString stringWithFormat:@"%d",[_priceLabel.text intValue] * num];
    }
}

- (IBAction)addTap:(id)sender {
    SelectAddViewController *selectAddVC = [[SelectAddViewController alloc] init];
    selectAddVC.delegate = self;
    selectAddVC.checkID = checkId;
    [self.navigationController pushViewController:selectAddVC animated:YES];
}

- (IBAction)surePayBtn:(id)sender {
    SelectPayViewController *selectPayVC = [[SelectPayViewController alloc] init];
    [self.navigationController pushViewController:selectPayVC animated:YES];
}


#pragma mark - SelectAddViewControllerDelegate Method
- (void)selectedAdd:(NSString *)checkID {
    checkId = checkID;
    
    [self addList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
