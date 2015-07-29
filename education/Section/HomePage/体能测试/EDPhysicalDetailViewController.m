//
//  EDPhysicalDetailViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhysicalDetailViewController.h"
#import "EDPhysicalDetailHeadCell.h"
#import "EDPhysicalContentCell.h"

@interface EDPhysicalDetailViewController ()
{
    NSArray *dataArray;
    NSDictionary *dic;
    NSMutableArray *scoreArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation EDPhysicalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    dataArray = @[@"身高",@"体重",@"肺活量",@"五十米跑",@"坐位体前屈",@"50米*8往返跑",@"一分钟仰卧起坐",@"一分钟跳绳",@"八百米跑",@"一千米跑",@"引体向上"];
    
    [self AFNRequest];
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hiddenView
{
    _msgView.hidden = YES;
}

- (void)AFNRequest
{
    scoreArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,@"xxid":_detailId};
    
    NSString *urlString = [NSString stringWithFormat:@"%@StudentHealth",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            
            dic = responseObject[@"data"];
            [scoreArray addObject:dic[@"XSSG"]];
            [scoreArray addObject:dic[@"XSTZ"]];
            [scoreArray addObject:dic[@"FHL"]];
            [scoreArray addObject:dic[@"WSMP"]];
            [scoreArray addObject:dic[@"ZWQQ"]];
            [scoreArray addObject:dic[@"WSCB"]];
            [scoreArray addObject:dic[@"YWQZ"]];
            [scoreArray addObject:dic[@"YFTS"]];
            [scoreArray addObject:dic[@"BBMP"]];
            [scoreArray addObject:dic[@"YQMP"]];
            [scoreArray addObject:dic[@"YTXS"]];
            
            [_tableView reloadData];
        }else
        {
            _msgView.hidden = NO;
            _msgLabel.text = responseObject[@"responseMessage"];
            [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
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
    return 1+dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 128;
    }else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row ==0) {
        EDPhysicalDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        if (headCell == nil) {
            headCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPhysicalDetailHeadCell" owner:self options:nil]lastObject];
        }
        headCell.titleLabel.text = _titleString;
        headCell.nameLabel.text = [NSString stringWithFormat:@"学生姓名: %@",dic[@"XSXM"]];
        return headCell;
    }else
    {
        EDPhysicalContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDPhysicalContentCell" owner:self options:nil]lastObject];
        }
        contentCell.titleLabel.text = dataArray[indexPath.row-1];
        if (scoreArray.count !=0)
        {
            contentCell.scoreLabel.text = scoreArray[indexPath.row-1];

        }
        return contentCell;
        
    }
    
}

@end
