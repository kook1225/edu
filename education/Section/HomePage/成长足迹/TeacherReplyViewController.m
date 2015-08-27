//
//  TeacherReplyViewController.m
//  education
//
//  Created by zhujun on 15/7/27.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "TeacherReplyViewController.h"

@interface TeacherReplyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIButton *addImgBtn;
    int imageNum;
    UIImageView *imgView;
    NSString *TMP_UPLOAD_IMG_PATH;
    NSData *fileData;
    NSString *filePath;
    
    UIImagePickerController *pic;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end


@implementation TeacherReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)commitBtn:(id)sender {
    
    if ([_textView.text length] == 0 || [_textView.text isEqualToString:@"想记录点什么.."]) {
        SHOW_ALERT(@"提示", @"内容不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                    @"xsid":_studentId,
                                    @"xxid":@"",
                                    @"title":@"",
                                    @"content":_textView.text,
                                    @"picadd":@"",
                                    @"type":@"2"};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
        
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {           [HUD hide:YES];
                  
                  if ([responseObject[@"responseCode"] intValue] == 0) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark textView 代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _textView.text = @"";
    return YES;
}

@end
