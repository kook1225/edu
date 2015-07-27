//
//  EDGrowDetailViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGrowDetailViewController.h"

@interface EDGrowDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIButton *addImgBtn;
    int imageNum;
    UIImageView *imgView;
    NSString *TMP_UPLOAD_IMG_PATH;
    NSData *fileData;
    NSString *filePath;
    NSMutableString *picAdd;
    
    UIImagePickerController *pic;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end


@implementation EDGrowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    picAdd = [NSMutableString string];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
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

- (void)drawlayer
{
    imageNum = 0;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.layer.masksToBounds = YES;
    
    
    addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.frame = CGRectMake(10, 10, 78, 78);
    [addImgBtn setImage:[UIImage imageNamed:@"addImg"] forState:UIControlStateNormal];
    [addImgBtn addTarget:self action:@selector(addImageView) forControlEvents:UIControlEventTouchUpInside];
    [_containView addSubview:addImgBtn];
    
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
    
    imgView.frame = CGRectMake(10+74*(num-1), 10, 70, 70);
    imgView.tag = 400+num;
    
    
    imgView.image = img;
    [_containView addSubview:imgView];
    addImgBtn.frame = CGRectMake(10+74*num, 10, 70, 70);
}

- (IBAction)commitBtn:(id)sender {
    if ([_titleTextField.text length] == 0) {
        SHOW_ALERT(@"提示", @"标题不能为空");
    }
    else {
        if ([_textView.text length] == 0 || [_textView.text isEqualToString:@"想记录点什么.."]) {
            SHOW_ALERT(@"提示", @"内容不能为空");
        }
        else {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"Loading";
            HUD.removeFromSuperViewOnHide = YES;
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                            @"xsid":@"",
                                            @"xxid":@"",
                                            @"title":_titleTextField.text,
                                            @"content":_textView.text,
                                            @"picadd":picAdd,
                                            @"type":@"1"};
            
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
            data = UIImagePNGRepresentation(image);
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
            
            if (imageNum == 3) {
                addImgBtn.hidden = YES;
            }
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"Loading";
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
