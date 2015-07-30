//
//  EvaluteAndEncourageViewController.m
//  education
//
//  Created by zhujun on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EvaluteAndEncourageViewController.h"
#import "EvaluteAndEncourageCell.h"
#import "growUpModel.h"
#import "IQKeyboardManager.h"

@interface EvaluteAndEncourageViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;


@end

@implementation EvaluteAndEncourageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    dataArray = [NSArray array];
    
    NSString *text = _model.FBNR;
    _nameLabel.text = [NSString stringWithFormat:@"%@留言",_model.FBRXM];
    _dateLabel.text = _model.FBSJ;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _contentLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH - 20, 500000);
    
    labelSize = [_contentLabel sizeThatFits:size];
    
    
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    _centerView.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame) + 10, SCREENWIDTH, 40);
    
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(_centerView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(_centerView.frame) - 124);
    
    [self replyApi];
    
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

- (void)viewWillAppear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)replyBtn:(id)sender {
    if ([_replyTextField.text length] == 0) {
        SHOW_ALERT(@"提示", @"内容不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                    @"xsid":_model.XSID,
                                    @"xxid":_model.ID,
                                    @"title":@"",
                                    @"content":_replyTextField.text,
                                    @"picadd":@"",
                                    @"type":@"3"};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
        
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {           [HUD hide:YES];
                  
                  if ([responseObject[@"responseCode"] intValue] == 0) {
                      
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                      alert.tag = 201;
                      [alert show];
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

- (void)replyApi
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //1405581
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"XXID":_model.ID,
                      @"pageSize":@"99999",
                      @"page":@"1"};
 
    
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
                 
                 _replyNumLabel.text = [NSString stringWithFormat:@"共%lu条回复",(unsigned long)[dataArray count]];
                 
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
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluteAndEncourageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluteAndEncourageCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluteAndEncourageCell" owner:self options:nil] lastObject];
    }
    
    [cell setData:[dataArray objectAtIndex:indexPath.row]];
    [cell setIntroductionText:[[dataArray objectAtIndex:indexPath.row] FBNR] name:[[dataArray objectAtIndex:indexPath.row] FBRXM]];
    return cell;
}

#pragma mark textView 代理
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _replyTextField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [self replyApi];
            [_replyTextField resignFirstResponder];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
