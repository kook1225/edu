//
//  EDMyOrderViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyOrderViewController.h"
#import "SETabBarViewController.h"
#import "EDMyOrderCell.h"
#import "EDOrderHeadCell.h"
#import "EDOrderBottomCell.h"
#import "EDOrderDetailViewController.h"
#import "MJRefresh.h"


#define LINEWIDTH SCREENWIDTH/4
@interface EDMyOrderViewController ()<MJRefreshBaseViewDelegate>
{
    SETabBarViewController *tabBarView;
    UIView *lineView;
    NSString *type;
    NSMutableArray *dataArray;
    
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    
    int pageNum;
}

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@end

@implementation EDMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    lineView.frame = CGRectMake(0, 43, LINEWIDTH, 2);
    [_headView addSubview:lineView];
    
    _nonDataLabel.hidden = YES;
    
    type = @"";
    [self AFNRequest:type];
 
    pageNum = 1;
    
    [self initfooterview];
    [self initheaderview];
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)AFNRequest:(NSString *)typeStr
{
    dataArray = [NSMutableArray array];
    
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
                                @"pageSize":@"10",
                                @"page":@"1",
                                @"status":typeStr};
    NSString *urlString = [NSString stringWithFormat:@"%@Order",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            if (responseObject[@"data"] == [NSNull null]) {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                _nonDataLabel.hidden = YES;
                _tableView.hidden = NO;
                dataArray = responseObject[@"data"];
                [_tableView reloadData];
            }
            
            
        }else
        {
            SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
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

#pragma mark 订单类型
- (IBAction)typeBtnFunction:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[_headView viewWithTag:i+400];
        if(i != button.tag-400)
        {
            [btn setSelected:NO];
        }
        
    }
    switch (button.tag) {
        case 400:
            type = @"";
            
            lineView.frame = CGRectMake(0, 43, LINEWIDTH, 2);
            break;
        case 401:
            type = @"1";
            lineView.frame = CGRectMake(LINEWIDTH, 43, LINEWIDTH, 2);
            break;
        case 402:
            type = @"2";
            lineView.frame = CGRectMake(2*LINEWIDTH, 43, LINEWIDTH, 2);
            break;
        case 403:
            type = @"3";
            lineView.frame = CGRectMake(3*LINEWIDTH, 43, LINEWIDTH, 2);
            break;
            
        default:
            break;
    }
    [self AFNRequest:type];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 172;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section--%ld",(long)indexPath.section);
     NSLog(@"row--%ld",(long)indexPath.row);
    
    
    
        EDMyOrderCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"orderContent"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDMyOrderCell" owner:self options:nil]lastObject];
        }
        if (dataArray.count !=0) {
            [contentCell setDataDic:dataArray[indexPath.row]];
        }
    
        return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EDOrderDetailViewController *orderDetaiVC = [[EDOrderDetailViewController alloc]init];
    orderDetaiVC.dic = dataArray[indexPath.row];
    [self.navigationController pushViewController:orderDetaiVC animated:YES];
    
}

#pragma mark 刷新
//下拉刷新和上拉加载相关
- (void)dealloc{
    [_footerview free];
    [_headerview free];
}

- (void)initfooterview{
    _footerview = [[MJRefreshFooterView alloc]initWithScrollView:_tableView];
    _footerview.delegate = self;
}

- (void)initheaderview{
    _headerview = [[MJRefreshHeaderView alloc]initWithScrollView:_tableView];
    _headerview.delegate = self;
}

//下拉刷新和上拉加载代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseview = refreshView;
    if (_baseview == _footerview) {
        
        pageNum++;
        
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
                                    @"pageSize":@"10",
                                    @"page":[NSNumber numberWithInt:pageNum],
                                    @"status":type};
        NSString *urlString = [NSString stringWithFormat:@"%@Order",SERVER_HOST];
        
        [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject);
            NSError *error;
            NSLog(@"error---%@",error);
            if ([responseObject[@"responseCode"] intValue] ==0)
            {
                NSLog(@"res---%@",responseObject[@"data"]);
                if (responseObject[@"data"] != [NSNull null])
                {
                    [dataArray addObjectsFromArray:responseObject[@"data"]];
                    [_tableView reloadData];
                }
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
        
        
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.5];
    }
    if (_baseview == _headerview) {
        [self AFNRequest:type];
        //        _baseview = refreshView;
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.5];
    }
    
}

- (void)hidden
{
    if (_baseview == _headerview)
    {
        [_headerview endRefreshing];
    }
    else
    {
        [_footerview endRefreshing];
    }
}
@end
