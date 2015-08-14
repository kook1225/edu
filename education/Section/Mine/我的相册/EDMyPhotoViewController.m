//
//  EDMyPhotoViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyPhotoViewController.h"
#import "SETabBarViewController.h"
#import "EDMyPhotoCell.h"
#import "EDPhotoDetailViewController.h"
#import "MJRefresh.h"

@interface EDMyPhotoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
    NSMutableArray *stringArray;
    NSMutableArray *imagesArray;
    NSMutableArray *imageArrays;
    
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@end

@implementation EDMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"相册";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    pageNum = 1;
    
    [self initfooterview];
    [self initheaderview];
    
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    dataArray = [NSMutableArray array];
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    
    [self album];
}


- (void)album {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"pageSize":@"10",
                  @"page":@"1"};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@StudentAlbums",SERVER_HOST];
    
    // 设置超时时间
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 
                 dataArray = [ListModel arrayOfModelsFromDictionaries:responseObject[@"data"][@"list"] error:&err];
                 
                 for (int i = 0; i < [dataArray count]; i++) {
                     [stringArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].TPSM];
                     [imagesArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].SLT];
                 }
                 NSLog(@"imagesArray:%@",imagesArray);
                 [_tableView reloadData];
                 
             }
             else {
                 _msgView.hidden = NO;
                 _msgLabel.text = responseObject[@"responseMessage"];
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

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMyPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EDMyPhotoCell" owner:self options:nil] lastObject];
    }
    
    imageArrays = [NSMutableArray array];
    
    NSString *imageStr = [imagesArray objectAtIndex:indexPath.row];
    
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row]] image:imageArrays reply:[dataArray objectAtIndex:indexPath.row] index:indexPath.row];
    [cell setData:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhotoDetailViewController *photoDetailVC = [[EDPhotoDetailViewController alloc]init];
    photoDetailVC.model = [dataArray objectAtIndex:indexPath.row];
    photoDetailVC.xxId = [[[dataArray objectAtIndex:indexPath.row] dynamicInfo] ID];
    photoDetailVC.album = @"相册";
    [self.navigationController pushViewController:photoDetailVC animated:YES];
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
        
        NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                    @"pageSize":@"10",
                                    @"page":[NSNumber numberWithInt:pageNum]};
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@StudentAlbums",SERVER_HOST];
        
        [manager GET:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            
            // NSError *err;
            
            if ([responseObject[@"responseCode"] intValue] ==0) {
                
                // dataArray = [growUpModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                if(responseObject[@"data"] != [NSNull null])
                {
                    [dataArray addObjectsFromArray:[ListModel arrayOfModelsFromDictionaries:responseObject[@"data"]]];
                }
                
                
                
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
        [self album];
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
