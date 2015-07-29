//
//  EDSendMsgViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDSendMsgViewController.h"

#define IMGWIDTH ([UIScreen mainScreen].bounds.size.width >= 667? 80 : 70)
@interface EDSendMsgViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIButton *addImgBtn;
    UIImageView *imgView;
    int imageNum;
    NSString *filePath;
    NSData *fileData;
    UIImagePickerController *picker;
    
    NSMutableString *picAdd;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end
NSString *TMP_UPLOAD_IMG_PATH=@"";
@implementation EDSendMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发送私信";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    picAdd = [NSMutableString string];
    [self drawlayer];
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

- (void)drawlayer
{
    imageNum = 0;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    _commitBtn.layer.cornerRadius = 4.0f;
    _commitBtn.layer.masksToBounds = YES;
    
    
    addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.frame = CGRectMake(10, 10, 78, 78);
    [addImgBtn setImage:[UIImage imageNamed:@"addImg"] forState:UIControlStateNormal];
    [addImgBtn addTarget:self action:@selector(addImageView) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:addImgBtn];
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
   
}
- (IBAction)sendFuction:(id)sender {
    
    NSLog(@"detailID---%@",_detailId);
    if ([_textView.text length] == 0 || [_textView.text isEqualToString:@"想和老师/小伙伴说些什么呢？"]) {
        SHOW_ALERT(@"提示", @"内容不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                    @"targetId":_detailId,
                                    @"images":picAdd,
                                    @"content":_textView.text,
                                    @"clientType":@"2",
                                    @"targetType":_type
                                    };
        
        NSString *urlStr = [NSString stringWithFormat:@"%@PrivateMessage",SERVER_HOST];
        
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {            [HUD hide:YES];
                  
                  if ([responseObject[@"responseCode"] intValue] == 0) {
                      _msgView.hidden = NO;
                      _msgLabel.text = responseObject[@"responseMessage"];
                      [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else {
                      _msgView.hidden = NO;
                      _msgLabel.text = responseObject[@"responseMessage"];
                      [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
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
    [_headView addSubview:imgView];
    addImgBtn.frame = CGRectMake(10+74*num, 10, 70, 70);
    
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
        [self localPhoto];
        
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.navigationController presentViewController:picker animated:YES completion:^(){}];
    }else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)localPhoto
{
    picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.navigationController presentViewController:picker animated:YES completion:^(){}];
}

#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController*)pk
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //先把图片转成NSData
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* images = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        //压缩图片
        CGSize imageSize = images.size;
        CGSize thumbImageSize = CGSizeMake(imageSize.width/2,  imageSize.height/2);
        UIGraphicsBeginImageContext(thumbImageSize);
        [images drawInRect:CGRectMake(0, 0, thumbImageSize.width,thumbImageSize.height)];
        images = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *data;
        if (UIImagePNGRepresentation(images) == nil)
        {
            data = UIImageJPEGRepresentation(images, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(images);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        NSString *imagePath= @"/head_image.png";
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imagePath] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [DocumentsPath stringByAppendingPathComponent:imagePath];
        fileData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
        //上传图片
        [pk dismissViewControllerAnimated:YES completion:^{
            imageNum++;
           
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pk{
    [pk dismissViewControllerAnimated:YES completion:^{
    }];
}
@end

