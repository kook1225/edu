//
//  EDOrderDetailViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDOrderDetailViewController.h"
#import "SETabBarViewController.h"
#import <UIImageView+WebCache.h>
#import "SelectPayViewController.h"

@interface EDOrderDetailViewController ()<UIAlertViewDelegate>
{
    SETabBarViewController *tabBarView;
}

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@end

@implementation EDOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!IOS7_LATER) {
        if (SCREENHEIGHT ==480) {
            _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 560);
        }
    }
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hidden
{
    _msgView.hidden = YES;
    [self.delegate setTableViewReload:[NSString stringWithFormat:@"%@",_type]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)drawlayer
{
    _commitBtn.layer.cornerRadius = 4.0f;
    _commitBtn.layer.masksToBounds = YES;
    
    _cancelBtn.layer.cornerRadius = 4.0f;
    _cancelBtn.layer.masksToBounds = YES;
    
    _cancelBtn.layer.borderColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor;
    _cancelBtn.layer.borderWidth = 1.0;
    _nonAddress.hidden = YES;
    _cancelBtn.hidden = YES;
    
    if([_dic[@"productinfo"][@"typename"] isEqualToString:@"VIP优惠包"])
    {
        _commitBtn.hidden = YES;
    }else
    {
        _commitBtn.hidden  = NO;
       
    }
    
    
    NSString *status;
    if ([_dic[@"orderinfo"][@"status"] intValue] ==0) {
        status = @"已取消";
        _bottomView.hidden = YES;
    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==1) {
        status = @"待支付";
        _cancelBtn.hidden = NO;
        [_commitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==2) {
        status = @"待发货";
        [_commitBtn setTitle:@"申请退款" forState:UIControlStateNormal];

    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==3) {
        status = @"待收货";
        if([_dic[@"productinfo"][@"typename"] isEqualToString:@"VIP优惠包"])
        {
            _commitBtn.hidden = YES;
        }else
        {
            _commitBtn.hidden  = NO;
            [_commitBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
        

    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==4) {
        status = @"交易成功";
        _bottomView.hidden = YES;
    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==5) {
        status = @"退单中";
        _bottomView.hidden = YES;
    }else if ([_dic[@"orderinfo"][@"status"] intValue] ==6) {
        status = @"退单成功";
        _bottomView.hidden = YES;
    }
    _orderStatus.text = status;
    _orderPrice.text = [NSString stringWithFormat:@"￥%@",_dic[@"orderinfo"][@"amount"]];
    
    _orderNum.text = [NSString stringWithFormat:@"订单编号:%@",_dic[@"orderinfo"][@"order_num"]];
    _orderTime.text = [NSString stringWithFormat:@"订单时间%@",_dic[@"orderinfo"][@"create_time"]];
    
    if ([_dic[@"orderinfo"][@"contact"] length] <=0) {
        _nonAddress.hidden = NO;
        _userName.hidden = YES;
        _userPhone.hidden = YES;
        _userAddress.hidden = YES;
        _addressImg.hidden = YES;
    }else
    {
        _nonAddress.hidden = YES;
        _userName.hidden = NO;
        _userPhone.hidden = NO;
        _userAddress.hidden = NO;
        _addressImg.hidden = NO;
        
        _userName.text = [NSString stringWithFormat:@"收货人:%@",_dic[@"orderinfo"][@"contact"]];
        _userPhone.text = _dic[@"orderinfo"][@"tel"];
        _userAddress.text = [NSString stringWithFormat:@"收货地址:%@",_dic[@"orderinfo"][@"address"]];
    }
    
    _goodsName.text = [NSString stringWithFormat:@"￥%@",_dic[@"productinfo"][@"name"]];
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,_dic[@"productinfo"][@"samll_img"]];
    NSURL *url = [NSURL URLWithString:imgString];
    [_goodsImg  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
    _goodsNum.text = [NSString stringWithFormat:@"数量:*%@",_dic[@"orderinfo"][@"num"]];
    
    _goodsOriPrice.text = [NSString stringWithFormat:@"￥%@",_dic[@"productinfo"][@"market_price"]];
    _goodsPrice.text = [NSString stringWithFormat:@"%@",_dic[@"productinfo"][@"sale_price"]];
  

}
- (IBAction)cancaelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    [alert show];

}

- (IBAction)commitBtn:(id)sender
{
    if([_dic[@"orderinfo"][@"status"] intValue] ==2)
    {
        [self statusAFNRequst:@"5"];
    }else
    {

        SelectPayViewController *selectPayVC = [[SelectPayViewController alloc] init];
        selectPayVC.orderId = _dic[@"orderinfo"][@"order_num"];
        selectPayVC.priceStr = _dic[@"orderinfo"][@"amount"];
        selectPayVC.proName = _dic[@"productinfo"][@"name"];
        selectPayVC.proIntro = _dic[@"productinfo"][@"intro"];
        selectPayVC.typeName = _dic[@"productinfo"][@"typename"];
        selectPayVC.type = @"订单";
        [self.navigationController pushViewController:selectPayVC animated:YES];
        
    }
    
    
    
    /*
    if ([_noteTextField.text isEqualToString:@""]) {
        _msgView.hidden = NO;
        _msgLabel.text = @"买家留言不能为空";
        [self performSelector:@selector(hidden) withObject:self afterDelay:2.0];
    }else
    {
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
                                    @"product_id":_dic[@"productinfo"][@"id"],
                                    @"member_id":_dic[@"orderinfo"][@"member_id"],
                                    @"contact":_dic[@"orderinfo"][@"contact"],
                                    @"tel":_dic[@"orderinfo"][@"tel"],
                                    @"address":_dic[@"orderinfo"][@"address"],
                                    @"zipcode":_dic[@"orderinfo"][@"zip_code"],
                                    @"num":_dic[@"orderinfo"][@"num"],
                                    @"note":_noteTextField.text};
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@Order",SERVER_HOST];
        
        [manager POST:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject);
            if ([responseObject[@"responseCode"] intValue] ==0) {
                _msgView.hidden = NO;
                _msgLabel.text = responseObject[@"responseMessage"];
                [self performSelector:@selector(hidden) withObject:self afterDelay:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                _msgView.hidden = NO;
                _msgLabel.text = responseObject[@"responseMessage"];
                [self performSelector:@selector(hidden) withObject:self afterDelay:2.0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD setHidden:YES];
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

    }*/
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        return;
    }else
    {
        [self statusAFNRequst:@"0"];

    }
}

- (void)statusAFNRequst:(NSString *)num
{
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
                                @"order_num":_dic[@"orderinfo"][@"order_num"],
                                @"status":num,
                                };
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@setOrder",SERVER_HOST];
    
    [manager POST:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            _msgView.hidden = NO;
            _msgLabel.text = responseObject[@"responseMessage"];
            [self performSelector:@selector(hidden) withObject:self afterDelay:2.0];
           
        }else
        {
            
            SHOW_ALERT(@"提示", responseObject[@"responseMessage"])
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD setHidden:YES];
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
@end
