//
//  SelectPayViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SelectPayViewController.h"
#import "PayEndViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPayPlugin.h"

@interface SelectPayViewController ()<UPPayPluginDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SelectPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付";
    
    if ([_type  isEqual: @"订单"]) {
        _contentLabel.text = @"请尽快支付哟~";
    }
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"你需要支付 : ¥%@",_priceStr];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popOrderList)
                                                 name:@"PayEndViewController"
                                               object:@"popOrderList"];
    
    if ([_typeName  isEqual: @"VIP优惠包"]) {
        NSDictionary *typeName = @{@"typeName":_typeName};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectPayViewController"
                          object:@"vip"
                        userInfo:typeName];
    }
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popOrderList {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)zhifubaoPay:(id)sender {
    
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
    order.tradeNO = _orderId; //订单ID（由商家自行制定）
    order.productName = _proName; //商品标题
    order.productDescription = _proName; //商品描述
    order.amount = _priceStr; //商品价格
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
                //PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
                //[self.navigationController pushViewController:payEndVC animated:YES];
                
                PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
                payEndVC.typeName = _typeName;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payEndVC];
                
                payEndVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [self presentViewController:nav animated:NO completion:nil];
                
            }
        }];
        
    }
    
}
- (IBAction)yinLianPay:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                @"code":[SEUtils getUserInfo].TokenInfo.access_token,
                                @"order_num":_orderId,
                                @"descript":_proName,
                                };
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@UnionPay",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            [UPPayPlugin startPay:responseObject[@"data"] mode:@"00" viewController:self delegate:self];
            
        }else
        {
            
            SHOW_ALERT(@"提示", responseObject[@"responseMessage"])
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if (operation.response.statusCode == 401) {
            NSLog(@"请求超时");
            //   [SEUtils repetitionLogin];
        }else if(error.code == -1001)
        {
            SHOW_ALERT(@"提示", @"网络请求超时");
        }else if (error.code == -1009)
        {
            SHOW_ALERT(@"提示", @"网络连接已断开");
        }
        else {
            NSLog(@"Error:%@",error);
            NSLog(@"err:%@",operation.responseObject[@"message"]);
            //   SHOW_ALERT(@"提示",operation.responseObject[@"message"])
        }
    }];
    
    
}


-(void)UPPayPluginResult:(NSString*)result {
    if ([result isEqualToString:@"success"]) {
        PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
        payEndVC.typeName = _typeName;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payEndVC];
        
        payEndVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:nav animated:NO completion:nil];
    }
    else if ([result isEqualToString:@"fail"]) {
        SHOW_ALERT(@"提示", @"支付未完成");
    }
    else {
        SHOW_ALERT(@"提示", @"取消支付");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
