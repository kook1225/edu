//
//  LifeServiceViewController.m
//  education
//
//  Created by zhujun on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LifeServiceViewController.h"
#import "SETabBarViewController.h"
#import "AppDelegate.h"
#import "LifeServiceCell.h"
#import "FXBlurView.h"
#import "LifeServiceIntroViewController.h"
#import "LifeServiceListTypeModel.h"
#import "ProductListModel.h"
#import "MJRefresh.h"

#define OFFSET ([UIScreen mainScreen].bounds.size.width > 320 ? 45 : 100)

#define VERSION ([UIScreen mainScreen].bounds.size.width > 320 ? ([UIScreen mainScreen].bounds.size.width <= 375 ? 2 : 3) : 1)

@interface LifeServiceViewController ()<MJRefreshBaseViewDelegate> {
    SETabBarViewController *tabBarViewController;
    NSMutableArray *titleArray;
    CGImageRef *context;
    CGFloat scale;
    UIView *menuView;
    FXBlurView *blurView;
    NSArray *dataArray;
    NSMutableArray *listArray;
    
    BOOL menu;
    
    MJRefreshBaseView *_baseview;
    MJRefreshFooterView *_footerview;
    MJRefreshHeaderView *_headerview;
    
    int btnTag;
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;

@end

@implementation LifeServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活服务";
    
    scale = SCALE;
    
    menu = NO;
    
    _nonDataLabel.hidden = YES;
    
    titleArray = [NSMutableArray array];
    dataArray = [NSArray array];
    listArray = [NSMutableArray array];
    
    [titleArray addObject:@"全部"];
    
    
    btnTag = 0;
    pageNum = 1;
    
    [self initfooterview];
    [self initheaderview];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    
    [self productType];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    [self.collectionView registerClass:[LifeServiceCell class] forCellWithReuseIdentifier:@"lifeServiceCell"];
 
}

- (void)viewDidAppear:(BOOL)animated {
    _scrollView.contentSize = CGSizeMake(60*[titleArray count],0);
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)productType {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Product",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              NSError *err;
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  dataArray = [LifeServiceListTypeModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                  
                  for (int i = 0; i < [dataArray count]; i++) {
                      [titleArray addObject:[[dataArray objectAtIndex:i] name]];
                  }
                  
                  // 是否设置回弹效果
                  _scrollView.tag = 501;
                  _scrollView.contentOffset = CGPointMake(0, 0);
                  
                  //titleArray = [NSMutableArray arrayWithArray:@[@"全部",@"公告",@"活动",@"求助",@"社交",@"提问"]];
                  
                  blurView = [FXBlurView new];
                  [blurView setFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), SCREENWIDTH, SCREENHEIGHT - 64 - _scrollView.frame.size.height)];
                  [blurView setTintColor:[UIColor whiteColor]];
                  [blurView setAlpha:0.95];
                  [self.view addSubview:blurView];
                  
                  for (int i = 0; i < [titleArray count]; i++) {
                      UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 * scale + (SCREENHEIGHT / 4.0 - 62 * scale) * (i - 4 * (i / 4)) , 20 + (i / 4) * ((30 * scale) + 20), 60 * scale, 30 * scale)];
                      [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                      btn.titleLabel.font = [UIFont systemFontOfSize:15];
                      btn.backgroundColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000];
                      [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                      btn.layer.cornerRadius = 5.0f;
                      btn.layer.borderColor = [UIColor colorWithRed:212.0/255.0f green:212.0/255.0f blue:212.0/255.0f alpha:1.000].CGColor;
                      btn.layer.borderWidth = 1;
                      btn.tag = 300 + i;
                      [btn addTarget:self action:@selector(titleBtn:) forControlEvents:UIControlEventTouchUpInside];
                      
                      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                      
                      [blurView addSubview:btn];
                  }
                  
                  
                  blurView.hidden = YES;
                  
                  
                  for (int i = 0; i < [titleArray count]; i++) {
                      UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60*i, 0, 60, 39)];
                      btn.backgroundColor = [UIColor whiteColor];
                      btn.tag = i + 400;
                      
                      [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                      [btn setTitleColor:[UIColor colorWithRed:255.0 / 255.0 green:126.0 / 255.0 blue:4.0 / 255.0 alpha:1] forState:UIControlStateSelected];
                      
                      btn.titleLabel.font = [UIFont systemFontOfSize:15];
                      
                      if (btn.tag == 400) {
                          [btn setSelected:YES];
                          btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                      }
                      
                      [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
                      [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                      [_scrollView addSubview:btn];
                  }
                  
                  if ([_vipStr  isEqual: @"成为vip"]) {
                      for (int i = 0; i < [titleArray count]; i++) {
                          if ([titleArray[i]  isEqual: @"VIP优惠包"]) {
                              UIButton *btn = (UIButton *)[_scrollView viewWithTag:400+i];
                              [self selectBtn:btn];
                              btnTag = i;
                          }
                      }
                      
                  }
                  
                  [self productList:btnTag];
                  
                  UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, -25, 60*[titleArray count], 1)];
                  borderView.backgroundColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000];
                  
                  [_scrollView addSubview:borderView];
                  
                  [_collectionView reloadData];
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

- (void)productList:(int)tag {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    if (tag == 0) {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"status":@"0",
                      @"type":@"",
                      @"page":@"1",
                      @"pageSize":@"8"};
    }
    else {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"status":@"0",
                      @"type":[[dataArray objectAtIndex:tag - 1] id],
                      @"page":@"1",
                      @"pageSize":@"8"};
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Product",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 if ([responseObject[@"data"] count] == 0) {
                     _collectionView.hidden = YES;
                     _nonDataLabel.hidden = NO;
                 }
                 else {
                     _collectionView.hidden = NO;
                     _nonDataLabel.hidden = YES;
                     listArray = [ProductListModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                     [_collectionView reloadData];
                 }
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

- (void)selectBtn:(id)sender {
    for (int i = 400; i < [titleArray count] + 400; i++) {
        UIButton *btn = (UIButton *)[_scrollView viewWithTag:i];
        if ([sender tag] == btn.tag) {
            btnTag = (int)[sender tag] - 400;
            
            [self productList:btnTag];
            
            [btn setSelected:YES];
            [UIView animateWithDuration:1 animations:^{
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            }];
            
            UIButton *button = (UIButton *)sender;
            NSLog(@"tag:%ld",(long)button.tag);
            //NSLog(@"xxxxx:%g",_scrollView.contentOffset.x);
            
            switch (VERSION) {
                case 1:
                    if ([titleArray count] > 4) {
                        if (button.frame.origin.x > (_scrollView.frame.size.width / 2.0)) {
                            if ((button.tag - 400) >= [titleArray count] - 3) {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake((60 * [titleArray count]) -_scrollView.frame.size.width, 0);
                                }];
                            }
                            else {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake(60 * (i - 402), 0);
                                }];
                            }
                        }
                        else {
                            [UIView animateWithDuration:0.3 animations:^{
                                _scrollView.contentOffset = CGPointMake(0, 0);
                            }];
                        }
                    }
                    break;
                case 2:
                    if ([titleArray count] > 5) {
                        if (button.frame.origin.x > (_scrollView.frame.size.width / 2.0)) {
                            if ((button.tag - 400) >= [titleArray count] - 3) {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake((60 * [titleArray count]) -_scrollView.frame.size.width, 0);
                                }];
                            }
                            else {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake(60 * (i - 402), 0);
                                }];
                            }
                        }
                        else {
                            [UIView animateWithDuration:0.3 animations:^{
                                _scrollView.contentOffset = CGPointMake(0, 0);
                            }];
                        }
                    }
                    break;
                    
                default:
                    if ([titleArray count] > 6) {
                        if (button.frame.origin.x > (_scrollView.frame.size.width / 2.0)) {
                            if ((button.tag - 400) >= [titleArray count] - 3) {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake((60 * [titleArray count]) -_scrollView.frame.size.width, 0);
                                }];
                            }
                            else {
                                [UIView animateWithDuration:0.3 animations:^{
                                    _scrollView.contentOffset = CGPointMake(60 * (i - 402), 0);
                                }];
                            }
                        }
                        else {
                            [UIView animateWithDuration:0.3 animations:^{
                                _scrollView.contentOffset = CGPointMake(0, 0);
                            }];
                        }
                    }
                    break;
            }
            
        
        }
        else {
            [btn setSelected:NO];
            [UIView animateWithDuration:1 animations:^{
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
            }];
        }
    }

}

- (void)titleBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:124.0/255.0f blue:6.0/255.0f alpha:1.000];
    [btn setSelected:YES];
    for (int i = 0; i < [titleArray count]; i++) {
        UIButton *button = (UIButton *)[blurView viewWithTag:i+300];
        if (btn.tag != button.tag) {
            [button setSelected:NO];
            button.backgroundColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000];
        }
    }
    UIButton *titleBtn = (UIButton *)[_scrollView viewWithTag:btn.tag + 100];
    [self selectBtn:titleBtn];
    blurView.hidden = YES;
    menu = NO;
    [_menuBtn setImage:[UIImage imageNamed:@"upBtn"] forState:UIControlStateNormal];
}


- (IBAction)menuBtn:(id)sender {
    if (!menu) {
        blurView.hidden = NO;
        [_menuBtn setImage:[UIImage imageNamed:@"downBtn"] forState:UIControlStateNormal];
        menu = YES;
    }
    else {
        blurView.hidden = YES;
        [_menuBtn setImage:[UIImage imageNamed:@"upBtn"] forState:UIControlStateNormal];
        menu = NO;
    }
}

#pragma mark - UICollectionView的api

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [listArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    LifeServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"lifeServiceCell" forIndexPath:indexPath];
    [cell setData:[listArray objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH / 2.0 - 15, 180 * scale);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LifeServiceIntroViewController *lifeServiceIntroVC = [[LifeServiceIntroViewController alloc] init];
    lifeServiceIntroVC.proId = [[listArray objectAtIndex:indexPath.row] id];
    [self.navigationController pushViewController:lifeServiceIntroVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark 刷新
//下拉刷新和上拉加载相关
- (void)dealloc{
    [_footerview free];
    [_headerview free];
}

- (void)initfooterview{
    _footerview = [[MJRefreshFooterView alloc]initWithScrollView:_collectionView];
    _footerview.delegate = self;
}

- (void)initheaderview{
    _headerview = [[MJRefreshHeaderView alloc]initWithScrollView:_collectionView];
    _headerview.delegate = self;
}

//下拉刷新和上拉加载代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseview = refreshView;
    if (_baseview == _footerview) {
        pageNum++;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter;
        
        if (btnTag == 0) {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"status":@"0",
                          @"type":@"",
                          @"page":[NSNumber numberWithInt:pageNum],
                          @"pageSize":@"8"};
        }
        else {
            parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                          @"status":@"0",
                          @"type":[[dataArray objectAtIndex:btnTag - 1] id],
                          @"page":[NSNumber numberWithInt:pageNum],
                          @"pageSize":@"8"};
        }
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@Product",SERVER_HOST];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager GET:urlStr parameters:parameter
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [HUD hide:YES];
                 
                 if ([responseObject[@"responseCode"] intValue] == 0) {
                     [listArray addObjectsFromArray:[ProductListModel arrayOfModelsFromDictionaries:responseObject[@"data"]]];
                     [_collectionView reloadData];
                     
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
        
        
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.5];
    }
    if (_baseview == _headerview) {
        pageNum = 1;
        [self productList:btnTag];
        //        _baseview = refreshView;
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.5];
    }
    
}

- (void)hidden
{
    if (_baseview == _headerview)
    {
        [_headerview endRefreshing];
    }
    else
    {
        [_footerview endRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
