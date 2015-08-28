//
//  EDInfomationViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDInfomationViewController.h"
#import "SETabBarViewController.h"
#import "EDDayInfoCell.h"
#import "IntroDetailViewController.h"
#import "EDInfoArrayModel.h"
#import "EDInfomationModel.h"
#import "MJRefresh.h"

@interface EDInfomationViewController ()<MJRefreshBaseViewDelegate>
{
    SETabBarViewController *tabBarView;
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    NSMutableArray *dataArray;
    NSArray *titleArray;
    UIView *lineView;
    int pageNum;
    
    NSString *typeString;
    
 }
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;


@end

@implementation EDInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"天天资讯";
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    pageNum = 1;
    
    [self initfooterview];
    [self initheaderview];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    

    [self TitleAFNRequest];
    
    _nonDataLabel.hidden = YES;
    
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)titleBtn:(NSArray *)array
{
    CGFloat BTN_WIDTH = SCREENWIDTH/array.count;
    for (int i=0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BTN_WIDTH*i, 0, BTN_WIDTH, 43);
        [button setTitle:array[i][@"FLM"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.tag = 400+i;
        [button addTarget:self action:@selector(titleBtnFunction:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:button];
        
        
    }
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:9/255.0f alpha:1.0];
    lineView.frame = CGRectMake(0, 43, BTN_WIDTH, 2);
    [_headView addSubview:lineView];
}
- (void)titleBtnFunction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"button tag is-----%ld",(long)button.tag);
    [button setSelected:YES];
    for (int i=400; i<400+titleArray.count; i++)
    {
        UIButton *btn = (UIButton *)[_headView viewWithTag:i];
        if (i != button.tag)
        {
            [btn setSelected:NO];
        }
    }
    CGFloat LINE_WIDTH = SCREENWIDTH/titleArray.count;
    lineView.frame = CGRectMake(LINE_WIDTH*(button.tag-400), 43, LINE_WIDTH, 2);
    typeString = titleArray[button.tag-400][@"FLM"];
    [self AFNRequest:titleArray[button.tag-400][@"FLM"]];
    
}
- (void)TitleAFNRequest
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token};
    NSString *urlString = [NSString stringWithFormat:@"%@NoticeList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            titleArray = responseObject[@"data"];
            typeString = titleArray[0][@"FLM"];
            [self AFNRequest:typeString];
            [self titleBtn:titleArray];
        }else
        {
            SHOW_ALERT(@"提示",responseObject[@"responseMessage"]);
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
                                @"type":@"1",
                                @"pagesize":@"10",
                                @"page":@"1",
                                @"zxtype":typeStr};
    NSString *urlString = [NSString stringWithFormat:@"%@NoticeList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            if (responseObject[@"data"] == [NSNull null]) {
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
    EDDayInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    if (infoCell == nil) {
        infoCell = [[[NSBundle mainBundle]loadNibNamed:@"EDDayInfoCell" owner:self options:nil]lastObject];
    }
    if(dataArray.count !=0)
    {
        [infoCell setdata:dataArray[indexPath.row]];
    }
    
    return infoCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntroDetailViewController *introDetailVC = [[IntroDetailViewController alloc] init];
    introDetailVC.detailId = [dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:introDetailVC animated:YES];
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
        [self AFNRequest:typeString];
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
