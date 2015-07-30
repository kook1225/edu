//
//  EDPrivateNoteViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPrivateNoteViewController.h"
#import "SETabBarViewController.h"
#import "EDPrivateNoteCell.h"
#import "EDPrivateNoteSelectedCell.h"
#import "EDPrivateDetailViewController.h"
#import "MJRefresh.h"

@interface EDPrivateNoteViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
    NSMutableArray *selectedArray;
    MJRefreshBaseView *_baseview;
    MJRefreshHeaderView * _headerview;
    MJRefreshFooterView * _footerview;
    int pageNum;
    
    NSString *type;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation EDPrivateNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的私信";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    selectedArray = [NSMutableArray array];
    type = @"2";
    [self AFNRequest:type];
    _nonDataLabel.hidden = YES;
    
    pageNum = 1;
    [self initfooterview];
    [self initheaderview];
    
    _buttonView.layer.cornerRadius = 4.0f;
    _buttonView.layer.masksToBounds = YES;
    _buttonView.layer.borderWidth = 1.0f;
    _buttonView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:124/255.0f  blue:6/255.0f  alpha:1.0f].CGColor;
    

}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendMsgFunction:(id)sender
{
    [_sendBtn setSelected:YES];
    [_receiveBtn setSelected:NO];
    type = @"1";
    [self AFNRequest:type];
}
- (IBAction)receiveMsgFunction:(id)sender
{
    [_sendBtn setSelected:NO];
    [_receiveBtn setSelected:YES];
    type = @"2";
    [self AFNRequest:type];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self AFNRequest:type];
}
- (void)AFNRequest:(NSString *)typeString
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
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                               @"type":typeString,
                               @"pageSize":@"10",
                               @"page":@"1"};
    
    NSString *urlString = [NSString stringWithFormat:@"%@PrivateMessage",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject[@"data"]);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if (responseObject[@"data"][@"list"] == [NSNull null])
            {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"list"]];
                
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
        
        pageNum ++;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                   @"type":type,
                                   @"pageSize":@"10",
                                   @"page":[NSNumber numberWithInt:pageNum]};
        
        NSString *urlString = [NSString stringWithFormat:@"%@PrivateMessage",SERVER_HOST];
        
        [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject[@"data"]);
            if ([responseObject[@"responseCode"] intValue] ==0) {
                
                [dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:responseObject[@"data"][@"list"]]];
                
                
                
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

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      if([dataArray[indexPath.row][@"messageInfo"][@"SFYD"] intValue] ==1)
      {
          EDPrivateNoteSelectedCell *selectedCell = [tableView dequeueReusableCellWithIdentifier:@"selected"];
          if (selectedCell == nil) {
              selectedCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteSelectedCell" owner:self options:nil]lastObject];
          }
          selectedCell.nameLabel.text = dataArray[indexPath.row][@"author"][@"XM"];
          selectedCell.contentLabel.text = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
          selectedCell.dateLabel.text = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
          return selectedCell;
      }else
      {
          EDPrivateNoteCell *nomalCell = [tableView dequeueReusableCellWithIdentifier:@"nomal"];
          if (nomalCell == nil) {
              nomalCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteCell" owner:self options:nil]lastObject];
          }
          nomalCell.nameLabel.text = dataArray[indexPath.row][@"author"][@"XM"];
          nomalCell.contentLabel.text = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
          nomalCell.dateLabel.text = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
          return nomalCell;
      }
    
    

        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if([type intValue] == 2)
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                   @"ID":dataArray[indexPath.row][@"messageInfo"][@"ID"]};
        
        NSString *urlString = [NSString stringWithFormat:@"%@PrivateMessage",SERVER_HOST];
        
        [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject[@"data"]);
            if ([responseObject[@"responseCode"] intValue] ==0) {
                
                EDPrivateDetailViewController *privateDetailVC = [[EDPrivateDetailViewController alloc]init];
                privateDetailVC.name = dataArray[indexPath.row][@"author"][@"XM"];
                privateDetailVC.date = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
                privateDetailVC.content = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
                privateDetailVC.imagesString = dataArray[indexPath.row][@"messageInfo"][@"TPDZ"];
                privateDetailVC.title = @"私信详情";
                privateDetailVC.type = @"私信";
                [self.navigationController pushViewController:privateDetailVC animated:YES];
                
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
    
    
    
    
  
}

@end
