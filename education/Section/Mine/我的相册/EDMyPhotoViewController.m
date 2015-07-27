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

@interface EDMyPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSArray *dataArray;
    NSMutableArray *stringArray;
    NSMutableArray *imagesArray;
    NSMutableArray *imageArrays;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"相册";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
}

- (void)viewWillAppear:(BOOL)animated {
    
    dataArray = [NSArray array];
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    
    [self album];
}

- (void)album {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
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

@end
