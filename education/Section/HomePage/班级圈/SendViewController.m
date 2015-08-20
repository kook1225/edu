//
//  SendViewController.m
//  education
//
//  Created by zhujun on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SendViewController.h"

#define IMGWIDTH ([UIScreen mainScreen].bounds.size.width >= 667? 80 : 70)
@interface SendViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIButton *addImgBtn;
    UIImageView *imgView;
    int imageNum;
    
    NSData *fileData;
    NSString *filePath;
    
    NSMutableString *picAdd;
    
    UIImagePickerController *pic;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end


@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    picAdd = [NSMutableString string];
    
    self.title = @"班级圈";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    [self drawlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtn {
    
    if ([_textView.text length] == 0 || [_textView.text isEqualToString:@"想和老师/小伙伴说些什么呢？"]) {
        SHOW_ALERT(@"提示", @"内容不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        NSDictionary *parameter;
        
        if ([[[[SEUtils getUserInfo] UserDetail] userinfo].YHLB intValue] == 3) {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"bjid":_bjid,
                          @"images":picAdd,
                          @"content":_textView.text,
                          };

        }
        else {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"bjid":@"",
                          @"images":picAdd,
                          @"content":_textView.text,
                          };

        }
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamic",SERVER_HOST];
        
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {            [HUD hide:YES];
                  
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

- (void)drawlayer
{
    imageNum = 0;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    
    addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.frame = CGRectMake(10, 10, 78, 78);
    [addImgBtn setImage:[UIImage imageNamed:@"addImg"] forState:UIControlStateNormal];
    [addImgBtn addTarget:self action:@selector(addImageView) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:addImgBtn];
    
    
}

- (void)addImageView
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
    
}
- (void)setImgFrame:(int )num image:(UIImage *)img
{
    imgView = [[UIImageView alloc]init];
    
    int slide_x = 0;
    
    if (SCREENWIDTH ==375) {
         slide_x = 140;
    }else if(SCREENWIDTH == 320)
    {
        slide_x = 113;
    }else
    {
        slide_x = 160;
    }
    
        if (num <3) {
            imgView.frame = CGRectMake(10+slide_x*(num-1), 10, 70, 70);
            imgView.tag = 400+num;
            imgView.image = img;
            [_headView addSubview:imgView];
            addImgBtn.frame = CGRectMake(10+slide_x*num, 10, 70, 70);
        }else if (num ==3)
        {
            _headView.frame = CGRectMake(0, 0, SCREENWIDTH, 95+80);
            _textView.frame = CGRectMake(10, CGRectGetMaxY(_headView.frame), SCREENWIDTH-20, 181);
            imgView.frame = CGRectMake(10+slide_x*(num-1), 10, 70, 70);
            imgView.tag = 400+num;
            imgView.image = img;
            [_headView addSubview:imgView];
            addImgBtn.frame = CGRectMake(10+slide_x*(num-3), 90, 70, 70);
        }
        else if (num <6)
        {
            imgView.frame = CGRectMake(10+slide_x*(num-4), 90, 70, 70);
            imgView.tag = 400+num;
            imgView.image = img;
            [_headView addSubview:imgView];
            addImgBtn.frame = CGRectMake(10+slide_x*(num-3), 90, 70, 70);
        }else if (num ==6)
        {
            _headView.frame = CGRectMake(0, 0, SCREENWIDTH, 95+80*2);
            if (SCREENHEIGHT == 480) {
                _textView.frame = CGRectMake(10, CGRectGetMaxY(_headView.frame), SCREENWIDTH-20, 150);

            }else
            {
                _textView.frame = CGRectMake(10, CGRectGetMaxY(_headView.frame), SCREENWIDTH-20, 181);

            }
            imgView.frame = CGRectMake(10+slide_x*(num-4), 90, 70, 70);
            imgView.tag = 400+num;
            imgView.image = img;
            [_headView addSubview:imgView];
            addImgBtn.frame = CGRectMake(10+slide_x*(num-6), 170, 70, 70);
        }else
        {
            imgView.frame = CGRectMake(10+slide_x*(num-7), 170, 70, 70);
            imgView.tag = 400+num;
            imgView.image = img;
            [_headView addSubview:imgView];
            addImgBtn.frame = CGRectMake(10+slide_x*(num-6), 170, 70, 70);
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

#pragma mark - UITextViewDelegate Method
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_textView.text  isEqual: @"想和老师/小伙伴说些什么呢？"]) {
        _textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([_textView.text  isEqual: @""]) {
        _textView.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
        _textView.text = @"想和老师/小伙伴说些什么呢？";
    }
    return YES;
}

#pragma mark UIAction 代理
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0){
        [self takePhoto];
        
    }
    else if(buttonIndex==1){
        [self LocalPhoto];
        
    }
}

#pragma mark 两种照片选择方式

-(void)takePhoto
{
    NSLog(@"11111");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        pic = [[UIImagePickerController alloc] init];
        pic.delegate = self;
        //设置拍照后的图片可被编辑
        pic.allowsEditing = YES;
        pic.sourceType = sourceType;
        [self presentViewController:pic animated:YES completion:^(){}];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    pic = [[UIImagePickerController alloc] init];
    
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.delegate = self;
    //设置选择后的图片可被编辑
    pic.allowsEditing = YES;
    [self presentViewController:pic animated:YES completion:^(){}];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)pk didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

        
        NSError *err;
        
        //fileData = [NSData dataWithContentsOfMappedFile:filePath];
        fileData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&err];
        
        //[SEUtils saveUserImage2:filePath];
        
        imageNum++;
        
        [pk dismissViewControllerAnimated:YES completion:^{
            
            
            [self setImgFrame:imageNum image:[UIImage imageWithContentsOfFile:filePath]];
            
            if (imageNum == 9) {
                addImgBtn.hidden = YES;
            }
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"加载中...";
            HUD.removeFromSuperViewOnHide = YES;
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                        @"extension":@"jpg"
                                        };
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/UploadAPI/",IMAGE_HOST];
            
            
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            
            [manager POST:urlStr parameters:parameter constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                //[formData appendPartWithFormData:fileData name:@"media"];
                [formData appendPartWithFileData:fileData name:@"media" fileName:@"1.jpg" mimeType:@"image/jpeg"];
            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [HUD hide:YES];
                      if ([responseObject[@"responseCode"] intValue] == 0) {
                          if (imageNum == 1) {
                              [picAdd appendString:[NSString stringWithFormat:@"%@",responseObject[@"data"]]];
                          }
                          else {
                              [picAdd appendString:[NSString stringWithFormat:@",%@",responseObject[@"data"]]];
                          }
                          
                          NSLog(@"pic:%@",picAdd);
                          
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
            
        }];
        
        
    }
    
}


@end


