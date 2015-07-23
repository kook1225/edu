//
//  EDPhotoDetailViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailViewController.h"
#import "EDPhotoDetailCell.h"
#import "CheckImageViewController.h"
#import "IQKeyboardManager.h"

@interface EDPhotoDetailViewController ()<UITextFieldDelegate> {
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation EDPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    _replyView.hidden = YES;
    
    [_tableView registerClass:[EDPhotoDetailCell class] forCellReuseIdentifier:@"photo"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seePic:)
                                                 name:@"EDPhotoDetailCell"
                                               object:@"seePict"];
}

- (void)viewWillAppear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _replyView.hidden = YES;
    [_replyTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _replyView.hidden = YES;
    [_replyTextField resignFirstResponder];
    return YES;
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)seePic:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    
    NSMutableArray *imageArrays = [NSMutableArray array];
    
    NSString *imageStr = _model.dynamicInfo.TPLY;
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    checkImageVC.dataArray = imageArrays;
    checkImageVC.page = [dic[@"tag"] intValue];
    
    [self.navigationController pushViewController:checkImageVC animated:YES];
}

- (void)zanBtn:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"dynamicId":[[_model dynamicInfo] ID]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamicLike",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  SHOW_ALERT(@"提示", @"点赞成功");
                  [self classCircleApi];
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

- (void)msgBtn:(id)sender {
    _replyView.hidden = NO;
    [_replyTextField becomeFirstResponder];
}

- (IBAction)replyButton:(id)sender {
    //NSLog(@"ddddddddd:%d",replyTag);
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"dynamicId":[[_model dynamicInfo] ID],
                  @"content":_replyTextField.text};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamicReply",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  SHOW_ALERT(@"提示", @"评论成功");
                  _replyView.hidden = YES;
                  [_replyTextField resignFirstResponder];
                  [self classCircleApi];
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

- (void)classCircleApi {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    // 当老师登录时注意获取班级id
    if ([[[[SEUtils getUserInfo] UserDetail] userinfo].YHLB intValue] == 3) {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"bjid":[[[[SEUtils getUserInfo] UserDetail] studentInfo] BJID],@"pageSize":@"10",@"page":@"1"};
    }
    else {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"bjid":@"",@"pageSize":@"10",@"page":@"1"};
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamic",SERVER_HOST];
    
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
                 _model = [dataArray objectAtIndex:[_index integerValue]];
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



#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhotoDetailCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    
    NSMutableArray *imageArrays = [NSMutableArray array];
    
    NSString *imageStr = _model.dynamicInfo.TPLY;
    
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    [photoCell setIntroductionText:_model.dynamicInfo.TPSM image:imageArrays comment:_model indexPath:indexPath.row];
    
    [photoCell setData:_model];
    
    [photoCell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoCell.msgBtn addTarget:self action:@selector(msgBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return photoCell;
}


@end
