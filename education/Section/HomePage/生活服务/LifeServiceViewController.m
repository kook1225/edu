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

#define OFFSET ([UIScreen mainScreen].bounds.size.width > 320 ? 45 : 100)

@interface LifeServiceViewController () {
    SETabBarViewController *tabBarViewController;
    NSArray *titleArray;
    CGImageRef *context;
    CGFloat scale;
    UIView *menuView;
    FXBlurView *blurView;
    
    BOOL menu;
}
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LifeServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活服务";
    
    scale = SCALE;
    
    menu = NO;
    
    titleArray = [NSArray array];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    // 是否设置回弹效果
    _scrollView.tag = 501;
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    titleArray = @[@"全部",@"公告",@"活动",@"求助",@"社交",@"提问",@"体育",@"生活",@"教育",@"政治",@"游戏"];
    
    // 按钮菜单
    /*
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), SCREENWIDTH, SCREENHEIGHT - 64 - _scrollView.frame.size.height)];
    menuView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    //[self.view addSubview:menuView];
    */
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
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, -25, 60*[titleArray count], 1)];
    borderView.backgroundColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000];
    
    [_scrollView addSubview:borderView];

    
    
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



- (void)selectBtn:(id)sender {
    for (int i = 400; i < [titleArray count] + 400; i++) {
        UIButton *btn = (UIButton *)[_scrollView viewWithTag:i];
        if ([sender tag] == btn.tag) {
            [btn setSelected:YES];
            [UIView animateWithDuration:1 animations:^{
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            }];
            
            UIButton *button = (UIButton *)sender;
            NSLog(@"tag:%ld",(long)button.tag);
            NSLog(@"xxxxx:%g",_scrollView.contentOffset.x);
            
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
    return [titleArray count];
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
    /*
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%ld",(long)indexPath.row);
     */
    LifeServiceIntroViewController *lifeServiceIntroVC = [[LifeServiceIntroViewController alloc] init];
    [self.navigationController pushViewController:lifeServiceIntroVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
