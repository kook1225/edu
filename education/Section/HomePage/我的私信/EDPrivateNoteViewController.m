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

@interface EDPrivateNoteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
    NSMutableArray *selectedArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [self AFNRequest];
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
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                               @"pageSize":@"10",
                               @"page":@"1"};
    
    NSString *urlString = [NSString stringWithFormat:@"%@PrivateMessage",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject[@"data"]);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"list"]];
            
            
            
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
    NSLog(@"index.row---%ld",(long)indexPath.row);
        for(int i =0;i<selectedArray.count;i++)
        {
            if ([NSNumber numberWithInteger:indexPath.row]  == selectedArray[i]) {
                EDPrivateNoteSelectedCell *selectedCell = [tableView dequeueReusableCellWithIdentifier:@"selected"];
                if (selectedCell == nil) {
                    selectedCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteSelectedCell" owner:self options:nil]lastObject];
                }
                selectedCell.nameLabel.text = dataArray[indexPath.row][@"author"][@"XM"];
                selectedCell.contentLabel.text = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
                selectedCell.dateLabel.text = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
                return selectedCell;
            }
            

        }
        EDPrivateNoteCell *nomalCell = [tableView dequeueReusableCellWithIdentifier:@"nomal"];
        if (nomalCell == nil) {
            nomalCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPrivateNoteCell" owner:self options:nil]lastObject];
        }
    nomalCell.nameLabel.text = dataArray[indexPath.row][@"author"][@"XM"];
    nomalCell.contentLabel.text = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
    nomalCell.dateLabel.text = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
        return nomalCell;

        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!([selectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]])) {
        [selectedArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    
    EDPrivateDetailViewController *privateDetailVC = [[EDPrivateDetailViewController alloc]init];
    privateDetailVC.name = dataArray[indexPath.row][@"author"][@"XM"];
    privateDetailVC.date = dataArray[indexPath.row][@"messageInfo"][@"FSSJ"];
    privateDetailVC.content = dataArray[indexPath.row][@"messageInfo"][@"XXNR"];
    privateDetailVC.imagesString = dataArray[indexPath.row][@"messageInfo"][@"TPDZ"];
    privateDetailVC.title = @"私信详情";
    privateDetailVC.type = @"私信";
    [self.navigationController pushViewController:privateDetailVC animated:YES];
   
    
    [_tableView reloadData];
}

@end
