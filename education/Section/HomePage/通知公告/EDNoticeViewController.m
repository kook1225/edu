//
//  EDNoticeViewController.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDNoticeViewController.h"
#import "SETabBarViewController.h"
#import "EDDayInfoCell.h"
#import "NoticeIntroViewController.h"
#import "MJRefresh.h"
#import "EDInfomationModel.h"
#import "EDInfoArrayModel.h"

@interface EDNoticeViewController ()<MJRefreshBaseViewDelegate>
{
    SETabBarViewController  *tabBarView;
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    NSMutableArray *dataArray;
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;

@end

@implementation EDNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通知公告";
    
    [self initfooterview];
    [self initheaderview];
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [self AFNRequest];
    pageNum = 1;
    
    _nonDataLabel.hidden = YES;
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
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                @"type":@"2",
                                @"pagesize":@"10",
                                @"page":@"1"};
    NSString *urlString = [NSString stringWithFormat:@"%@NoticeList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if (responseObject[@"data"] == [NSNull null])
            {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                EDInfomationModel *dic = [[EDInfomationModel alloc]initWithDictionary:responseObject[@"data"] error:nil];
                dataArray = [EDInfoArrayModel arrayOfModelsFromDictionaries:dic.list error:nil];
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDDayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EDDayInfoCell" owner:self options:nil]lastObject];
    }
    if (dataArray.count !=0) {
        [cell setdata:dataArray[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeIntroViewController *noticeIntroVC = [[NoticeIntroViewController alloc] init];
    noticeIntroVC.detailId = [dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:noticeIntroVC animated:YES];
}

#pragma mark 刷新
//下拉刷新相关
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

//下拉刷新代理
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
        
        NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                    @"type":@"1",
                                    @"pagesize":@"10",
                                    @"page":[NSNumber numberWithInt:pageNum]};
        NSString *urlString = [NSString stringWithFormat:@"%@NoticeList",SERVER_HOST];
        
        [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject);
            if ([responseObject[@"responseCode"] intValue] ==0) {
                EDInfomationModel *dic = [[EDInfomationModel alloc]initWithDictionary:responseObject[@"data"] error:nil];
                [dataArray addObjectsFromArray:[EDInfoArrayModel arrayOfModelsFromDictionaries:dic.list error:nil]];
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
