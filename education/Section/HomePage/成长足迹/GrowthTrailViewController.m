//
//  GrowthTrailViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "GrowthTrailViewController.h"
#import "SETabBarViewController.h"
#import "JournalCell.h"
#import "EDGrowDetailViewController.h"
#import "EvaluteAndEncourageViewController.h"
#import "EDPrivateDetailViewController.h"
#import "growUpModel.h"
#import "MJRefresh.h"

@interface GrowthTrailViewController ()<MJRefreshBaseViewDelegate> {
    SETabBarViewController *tabBarViewController;
    NSMutableArray *dataArray;
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GrowthTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长足迹";
    
    dataArray = [NSMutableArray array];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];

    pageNum = 1;
    
    [self initfooterview];
    [self initheaderview];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发表" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
}

- (void)viewWillAppear:(BOOL)animated {
    [self growUpApi];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)growUpApi {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //1405581
    NSDictionary *parameter;
    
    if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] YHLB] intValue] == 3) {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"XSID":_detailId,
                      @"pageSize":@"10",
                      @"page":@"1"};
    }
    else {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"XSID":[[[[SEUtils getUserInfo] UserDetail] studentInfo] XSID],
                      @"pageSize":@"10",
                      @"page":@"1"};
    }
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 dataArray = [growUpModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                 [_tableView reloadData];
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

- (void)sendBtn {
    EDGrowDetailViewController *growDetailVC = [[EDGrowDetailViewController alloc]init];
    [self.navigationController pushViewController:growDetailVC animated:YES];

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[dataArray objectAtIndex:indexPath.row] FBRLX] intValue] == 3) {
        EvaluteAndEncourageViewController *evaluteAndEncourageVC = [[EvaluteAndEncourageViewController alloc] init];
        [self.navigationController pushViewController:evaluteAndEncourageVC animated:YES];
    }
    else {
        EDPrivateDetailViewController *privateDetailVC = [[EDPrivateDetailViewController alloc] init];
        privateDetailVC.model = [dataArray objectAtIndex:indexPath.row];
        privateDetailVC.title = @"详情";
        privateDetailVC.type = @"成长足迹";
        [self.navigationController pushViewController:privateDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"journalCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JournalCell" owner:self options:nil] lastObject];
    }
    
    [cell setData:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
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
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSDictionary *parameter;
        
        if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] YHLB] intValue] == 3) {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"XSID":_detailId,
                          @"pageSize":@"10",
                          @"page":[NSNumber numberWithInt:pageNum]};
        }
        else {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"XSID":[[[[SEUtils getUserInfo] UserDetail] studentInfo] ID],
                          @"pageSize":@"10",
                          @"page":[NSNumber numberWithInt:pageNum]};
        }
    
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
        
        [manager GET:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            
           // NSError *err;
            
            if ([responseObject[@"responseCode"] intValue] ==0) {
                
               // dataArray = [growUpModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                
                [dataArray addObjectsFromArray:[growUpModel arrayOfModelsFromDictionaries:responseObject[@"data"]]];
                
                [_tableView reloadData];
                
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
        
        
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.5];
    }
    if (_baseview == _headerview) {
        [self growUpApi];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
