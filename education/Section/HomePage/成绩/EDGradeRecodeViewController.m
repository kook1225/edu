//
//  EDGradeRecodeViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGradeRecodeViewController.h"
#import "EDGradeRecodeCell.h"
#import "EDGradeDetailViewController.h"
#import "SETabBarViewController.h"
#import "MUScoreModel.h"
#import "MUScoreListModel.h"
#import "MJRefresh.h"

@interface EDGradeRecodeViewController ()<MJRefreshBaseViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;

@end

@implementation EDGradeRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"成绩档案";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self AFNRequest];
    
    _nonDataLabel.hidden = YES;
    pageNum = 1;
    [self initfooterview];
    [self initheaderview];
    
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)AFNRequest
{
    dataArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters;
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3) {
        //老师
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"XSID":_detailId,
                     @"page":@"1",
                     @"pageSize":@"10"
                     };
    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"XSID":@"",
                     @"page":@"1",
                     @"pageSize":@"10"};
    }
    NSString *urlString = [NSString stringWithFormat:@"%@StudentScore",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            if (responseObject[@"data"] == [NSNull null]) {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                dataArray = [MUScoreModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:nil];
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

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDGradeRecodeCell *recodeCell = [tableView dequeueReusableCellWithIdentifier:@"recodeCell"];
    if (recodeCell == nil) {
        recodeCell = [[[NSBundle mainBundle]loadNibNamed:@"EDGradeRecodeCell" owner:self options:nil]lastObject];
    }
    [recodeCell setData:dataArray[indexPath.row]];
    return recodeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDGradeDetailViewController *gradeDetailVC = [[EDGradeDetailViewController alloc]init];
    gradeDetailVC.titleString = [dataArray[indexPath.row] KSMC];
    gradeDetailVC.dataArray = [dataArray[indexPath.row] list];
    [self.navigationController pushViewController:gradeDetailVC animated:YES];
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
        
        NSDictionary *pramaters;
        if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3) {
            //老师
            pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                         @"XSID":_detailId,
                         @"page":[NSNumber numberWithInt:pageNum],
                         @"pageSize":@"10"
                         };
        }else
        {
            pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                         @"XSID":@"",
                         @"page":[NSNumber numberWithInt:pageNum],
                         @"pageSize":@"10"};
        }
        NSString *urlString = [NSString stringWithFormat:@"%@StudentScore",SERVER_HOST];
        
        [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject);
            if ([responseObject[@"responseCode"] intValue] ==0) {
                [dataArray addObjectsFromArray:[MUScoreModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:nil]];
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
        [self AFNRequest];
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
