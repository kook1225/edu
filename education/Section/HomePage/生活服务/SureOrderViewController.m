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
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface SureOrderViewController ()<SelectAddViewControllerDelegate> {
    int num;
    NSString *checkId;
    NSArray *dataArray;
    NSString *recevieUser;
    NSString *zipCode;
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
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;


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
    [_leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
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
    HUD.labelText = @"加载中...";
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
                                 _recevieNameLabel.text = [NSString stringWithFormat:@"收货人 : %@",[dataArray[i] contact]];
                                 
                                 recevieUser = [dataArray[i] contact];
                                 
                                 _telLabel.text = [dataArray[i] tel];
                                 
                                 _addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dataArray[i] province],[dataArray[i] city],[dataArray[i] district],[dataArray[i] address]];
                                 _addLabel.numberOfLines = 2;
                                 [_addLabel sizeToFit];
                                 
                                 zipCode = [dataArray[i] zip_code];
                             }
                         }
                     }
                     else {
                         _recevieNameLabel.text = [NSString stringWithFormat:@"收货人 : %@",[dataArray[0] contact]];
                         
                         recevieUser = [dataArray[0] contact];
                         
                         _telLabel.text = [dataArray[0] tel];
                         
                         _addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dataArray[0] province],[dataArray[0] city],[dataArray[0] district],[dataArray[0] address]];
                         _addLabel.numberOfLines = 2;
                         [_addLabel sizeToFit];
                         
                         zipCode = [dataArray[0] zip_code];
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
        _totalPrice.text = [NSString stringWithFormat:@"%g",[_priceLabel.text floatValue] * num];
    }
}
- (IBAction)addBtn:(id)sender {
    if ([_numLabel.text intValue] < 99) {
        num++;
        _numLabel.text = [NSString stringWithFormat:@"%d",num];
        _goodsNumLabel.text = [NSString stringWithFormat:@"x %d",num];
        _totalPrice.text = [NSString stringWithFormat:@"%g",[_priceLabel.text floatValue] * num];
    }
}

- (IBAction)addTap:(id)sender {
    SelectAddViewController *selectAddVC = [[SelectAddViewController alloc] init];
    selectAddVC.delegate = self;
    selectAddVC.checkID = checkId;
    [self.navigationController pushViewController:selectAddVC animated:YES];
}

- (IBAction)surePayBtn:(id)sender {
    if ([_recevieNameLabel.text length] == 0) {
        SHOW_ALERT(@"提示",@"收货地址不能为空");
    }
    else {
        _surePayBtn.enabled = NO;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
     
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                    @"code":@"43242",
                                    @"product_id":_model.id,
                                    @"member_id":[[[[SEUtils getUserInfo] UserDetail] userinfo] ID],
                                    @"contact":recevieUser,
                                    @"tel":_telLabel.text,
                                    @"address":_addLabel.text,
                                    @"zipcode":zipCode,
                                    @"num":[NSNumber numberWithInt:num],
                                    @"note":@""
                                    };
     
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@Order",SERVER_HOST];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [HUD hide:YES];
                 _surePayBtn.enabled = YES;
                 
                 if ([responseObject[@"responseCode"] intValue] == 0) {
                     
                     
                     NSString *partner = @"2088021168383042";
                     NSString *seller = @"wufangedu_2015@163.com";
                     NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKwHL7Ib/pXiYLYX2oH9fWR48iW/zDnYf3HCCFGzLe45SB8F2NNs0f3cbw95RT/wFcivYtggD/06yzCWt91IJ8JcpHJ7E+mgwqDDL2B2xy81dzHpZTGQPfkZLQ4ycIDZoeVf/mczm6VXWoNnBHGuBYqzeWcSC8M5kq+MxKlmayXnAgMBAAECgYAzjOe/EOKGmdLvXlCNeZ/01sWBiGszvmvadBG4IeCWrbWuDjt+h/KZh1AErAuTcGemvt/48gq4kMDI67FnbzLybmpPIlH4tmDg2deuJPYwWhDc5TrUN6AT0i0o3zP043QHO1S3a+fCQRX1Xx4agMarThtBkdna0bKXvkijdQgE2QJBAOECT+NDM6mWBfmeH5oa6F68vIR8V55fKujMaFh4+B1791sUQTS5OVAfaQ7T0aN/tSlLYdkF8NAsK1hhNTUOnwUCQQDDuMvcboCliiE8qXxzcqFuQsGLjLz5d0/9tanSjVWeRboYT9Oux7/s5ZXhAIr9nZiuUb3GYoh+k9JC9Puy7Qz7AkEAgoKxzbMD+0COdKvXzq3+zDyS6BGrTKwMmn09pNt9prRp1AVakPdCnAusBzKrbTc84BfeSGAevtBvz9KKZxz09QJADMCHl88jVqXPUJKCZ0s6tWJoFd2PmnlpntAtRmirAWrtmxPoaOTe3mJ/B2/vnmKcRg9RXBGjbwvWkUJA/AFx7QJADlHIo51iRFa35k52a39LYH4xORPE5L2r9EWVVpR8f1SJylwIF5nyRv2inWQjOTJeyrAL9VNOxmv1uqL5m90/LQ==";
                     
                     
                     //partner和seller获取失败,提示
                     if ([partner length] == 0 || [seller length] == 0)
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"缺少partner或者seller。"
                                                                        delegate:self
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                         [alert show];
                         return;
                     }
                     
                     
                     //生成订单信息及签名
                     
                     //将商品信息赋予AlixPayOrder的成员变量
                     Order *order = [[Order alloc] init];
                     order.partner = partner;
                     order.seller = seller;
                     order.tradeNO = responseObject[@"data"][0][@"orderinfo"][@"order_num"]; //订单ID（由商家自行制定）
                     order.productName = _model.name; //商品标题
                     order.productDescription = _model.intro; //商品描述
                     order.amount = responseObject[@"data"][0][@"orderinfo"][@"amount"]; //商品价格
                     order.notifyURL = NOTIFLURL; //回调URL
                     
                     order.service = @"mobile.securitypay.pay";
                     order.paymentType = @"1";
                     order.inputCharset = @"utf-8";
                     order.itBPay = @"15m";
                     
                     //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                     NSString *appScheme = @"education";
                     
                     //将商品信息拼接成字符串
                     NSString *orderSpec = [order description];
                     NSLog(@"orderSpec = %@",orderSpec);
                     
                     //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                     id<DataSigner> signer = CreateRSADataSigner(privateKey);
                     NSString *signedString = [signer signString:orderSpec];
                     
                     //将签名成功字符串格式化为订单字符串,请严格按照该格式
                     NSString *orderString = nil;
                     if (signedString != nil) {
                         orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                        orderSpec, signedString, @"RSA"];
                         
                         [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                             
                             
                             NSLog(@"reslut = %@",resultDic);
                             
                             if ([resultDic[@"resultStatus"] intValue] == 9000) {
                                 SelectPayViewController *selectPayVC = [[SelectPayViewController alloc] init];
                                 [self.navigationController pushViewController:selectPayVC animated:YES];
                             }
                             
                         }];
                         
                         
                     }
                 
                 }
                 else {
                     SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [HUD hide:YES];
                 _surePayBtn.enabled = YES;
                 
                 if(error.code == -1001)
                 {
                     SHOW_ALERT(@"提示", @"网络请求超时");
                 }else if (error.code == -1009)
                 {
                     SHOW_ALERT(@"提示", @"网络连接已断开");
                 }
             }];
    }
    
    
    
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
