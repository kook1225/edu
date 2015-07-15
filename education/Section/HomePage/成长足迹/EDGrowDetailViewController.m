//
//  EDGrowDetailViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGrowDetailViewController.h"

@interface EDGrowDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIButton *addImgBtn;
    int imageNum;
    UIImageView *imgView;
    NSString *TMP_UPLOAD_IMG_PATH;
    NSData *fileData;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end


@implementation EDGrowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"日志心情";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    [self drawlayer];
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
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                @"xsid":@"",
                                @"xxid":@"",
                                @"titile":_titleTextField.text,
                                @"content":_textView.text,
                                @"type":@"1"};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameter constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"picadd" fileName:@"image.png" mimeType:@"image/png"];
        
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {             [HUD hide:YES];
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 
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
        [self snapImage];
        
    }
    else if(buttonIndex==1){
        [self pickImage];
        
    }
}
#pragma mark 两种照片选择方式

//拍照
- (void) snapImage
{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
//从相册里找
- (void) pickImage
{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark UIImagePicker 代理
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    imageNum++;
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(78, 78)];
    [self saveImage:newImg WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".png"]];
    
    [self setImgFrame:imageNum image:newImg];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    TMP_UPLOAD_IMG_PATH=fullPathToFile;
    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    NSLog(@"===new fullPathToFile===%@",fullPathToFile);
    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);

    fileData = [NSData dataWithContentsOfMappedFile:TMP_UPLOAD_IMG_PATH];
    
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    // transfer ownership of the string
    // to the autorelease pool
    
    // release the UUID
    CFRelease(uuid);
    return uuidString;
}

@end
