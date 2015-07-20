//
//  EDSetProblemViewController.m
//  education
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDSetProblemViewController.h"
#import "SETabBarViewController.h"

@interface EDSetProblemViewController ()<UITextViewDelegate>
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation EDSetProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问题反馈";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawlayer
{
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    
    _commitBtn.layer.cornerRadius = 4.0f;
    _commitBtn.layer.masksToBounds = YES;
    
}
- (IBAction)commitFunction:(id)sender
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                @"feedback":_textView.text,
                                @"type":@"4"};
    NSString *urlString = [NSString stringWithFormat:@"%@FeedBack",SERVER_HOST];
    
    
    [manager POST:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            
          SHOW_ALERT(@"提示",responseObject[@"responseMessage"] )
            
            
            
        }else
        {
            SHOW_ALERT(@"提示",responseObject[@"responseMessage"] );
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

#pragma mark textView代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _textView.text = @"";
    return YES;
}
@end
