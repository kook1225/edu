//
//  ClassCircleViewController.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ClassCircleViewController.h"
#import "SETabBarViewController.h"
#import "ClassCircleCell.h"
#import "SendViewController.h"
#import "EDPhotoDetailViewController.h"
#import "ClassCircleModel.h"
#import "ListModel.h"
#import "CheckImageViewController.h"
#import "IQKeyboardManager.h"

@interface ClassCircleViewController () {
    SETabBarViewController *tabBarViewController;
    NSMutableArray *stringArray;
    NSMutableArray *imagesArray;
    NSArray *dataArray;
    NSMutableArray *imageArrays;
    int replyTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;


@end

@implementation ClassCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级圈";
    
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    dataArray = [NSArray array];
    
    _replyView.hidden = YES;
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seePic:)
                                                 name:@"SETabBarViewController"
                                               object:@"seePic"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replyAction:)
                                                 name:@"ClassCircleCell"
                                               object:@"ReplyAction"];
}

- (void)viewWillAppear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self classCircleApi];
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

#pragma mark - Custom Method
- (void)backBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtn {
    SendViewController *sendVC = [[SendViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (IBAction)replyButton:(id)sender {
    //NSLog(@"ddddddddd:%d",replyTag);
    if ([_replyTextField.text length] == 0) {
        SHOW_ALERT(@"提示", @"评论不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter;
        
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"dynamicId":[[[dataArray objectAtIndex:replyTag] dynamicInfo] ID],
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
}

-(void)seePic:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    
    NSString *imageStr = [imagesArray objectAtIndex:[dic[@"tag"] intValue]/100];
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    checkImageVC.dataArray = imageArrays;
    checkImageVC.page = [dic[@"tag"] intValue]%100;
    
    [self.navigationController pushViewController:checkImageVC animated:YES];
}

-(void)replyAction:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    EDPhotoDetailViewController *photoDetail = [[EDPhotoDetailViewController alloc]init];
    photoDetail.model = [dataArray objectAtIndex:[dic[@"index"] intValue]];
    photoDetail.index = dic[@"index"];
    [self.navigationController pushViewController:photoDetail animated:YES];
}

// 点赞
- (void)evalutePri:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag----%d",(int)btn.tag - 400);
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"dynamicId":[[[dataArray objectAtIndex:btn.tag - 400] dynamicInfo] ID]};
    
    
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

// 回复
- (void)replyBtn:(id)sender {
    replyTag = 0;
    
    UIButton *btn = (UIButton *)sender;
    replyTag = (int)btn.tag - 500;
    _replyView.hidden = NO;
    [_replyTextField becomeFirstResponder];
}

- (void)classCircleApi {
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    // 当老师登录时注意获取班级id
    if ([[[[SEUtils getUserInfo] UserDetail] userinfo].YHLB intValue] == 3) {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"bjid":_detailId,@"pageSize":@"10",@"page":@"1"};
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
                 
                 for (int i = 0; i < [dataArray count]; i++) {
                     [stringArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].TPSM];
                     [imagesArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].SLT];
                 }
                 //NSLog(@"string---------:%@",stringArray);
                 //NSLog(@"array:%@",imagesArray);
                 
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

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stringArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCircleCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassCircleCell" owner:self options:nil] lastObject];
    }
    
    
    imageArrays = [NSMutableArray array];
    
    NSString *imageStr = [imagesArray objectAtIndex:indexPath.row];
    
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];

    
    //@[@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊a",@"范德萨范德萨范德萨范德萨大叔大叔的"]
    
    [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row]] image:imageArrays reply:[dataArray objectAtIndex:indexPath.row] index:indexPath.row];
    
    [cell setData:[dataArray objectAtIndex:indexPath.row]];
    cell.priBtn.tag = 400 + indexPath.row;
    [cell.priBtn addTarget:self action:@selector(evalutePri:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.rlyBtn.tag = 500 + indexPath.row;
    [cell.rlyBtn addTarget:self action:@selector(replyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
