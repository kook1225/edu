//
//  EDEditInfoViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDEditInfoViewController.h"
#import "SETabBarViewController.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"

@interface EDEditInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    SETabBarViewController *tabBarView;
    
    NSData *fileData;
    NSString *filePath;
    
    NSString *picAdd;
    
    UIImagePickerController *pic;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation EDEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资料";
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!IOS7_LATER)
    {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 800);
    }else
    {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 690);

    }
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawlayer
{
    _headImg.layer.cornerRadius = 4.0f;
    _headImg.layer.masksToBounds = YES;
    
    
    
    _userId.text = [SEUtils getUserInfo].UserDetail.userinfo.ID;
    _location.text = [SEUtils getUserInfo].UserDetail.studentInfo.QYMC;
    _school.text = [SEUtils getUserInfo].UserDetail.studentInfo.DWMC;
    _grade.text = [SEUtils getUserInfo].UserDetail.studentInfo.NJMC;
    _college.text = [SEUtils getUserInfo].UserDetail.studentInfo.BJMC;
    _userName.text = [SEUtils getUserInfo].UserDetail.studentInfo.XSXM;
    _sex.text = [SEUtils getUserInfo].UserDetail.studentInfo.XSXB;
//    _birthDay.text = [SEUtils getUserInfo].UserDetail.studentInfo.DWMC;
    _momName.text = [SEUtils getUserInfo].UserDetail.studentInfo.MQXM;
    _momPhone.text = [SEUtils getUserInfo].UserDetail.studentInfo.MQDH;
    _dadName.text = [SEUtils getUserInfo].UserDetail.studentInfo.FQXM;
    _dadPhone.text = [SEUtils getUserInfo].UserDetail.studentInfo.FQDH;
    
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,[SEUtils getUserInfo].UserDetail.userinfo.YHTX];
    NSURL *url = [NSURL URLWithString:imgString];
    [_headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
}
- (IBAction)changHeadImg:(id)sender {
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
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
        
        
        [pk dismissViewControllerAnimated:YES completion:^{
            
            [_headImg setImage:[UIImage imageWithContentsOfFile:filePath]];
            
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
                          
                          picAdd = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                          
                          //NSLog(@"pic:%@",picAdd);
                          
                          AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                          
                          NSDictionary *parameter;
                          
                          parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                        @"icon":picAdd};
                          
                          
                          NSString *urlStr = [NSString stringWithFormat:@"%@MyIcon",SERVER_HOST];
                          
                          // 设置超时时间
                          [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                          manager.requestSerializer.timeoutInterval = 10.f;
                          [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                          
                          [manager POST:urlStr parameters:parameter
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [HUD hide:YES];
                                    
                                    if ([responseObject[@"responseCode"] intValue] == 0) {
                                        [self userInfo];
                                        SHOW_ALERT(@"提示", @"修改成功");
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

- (void)userInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@MyInfo",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSError *err;
              
              UserModel *model = [[UserModel alloc] initWithDictionary:responseObject[@"data"] error:&err];
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
            
                  [SEUtils setUserInfo:model];
              }
              else {
                  SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if(error.code == -1001)
              {
                  SHOW_ALERT(@"提示", @"网络请求超时");
              }else if (error.code == -1009)
              {
                  SHOW_ALERT(@"提示", @"网络连接已断开");
              }
          }];
}

@end
