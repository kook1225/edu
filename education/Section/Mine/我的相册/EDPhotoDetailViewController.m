//
//  EDPhotoDetailViewController.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailViewController.h"
#import "EDPhotoDetailCell.h"
#import "CheckImageViewController.h"

@interface EDPhotoDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    [_tableView registerClass:[EDPhotoDetailCell class] forCellReuseIdentifier:@"photo"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seePic:)
                                                 name:@"EDPhotoDetailCell"
                                               object:@"seePict"];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)seePic:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    
    NSMutableArray *imageArrays = [NSMutableArray array];
    
    NSString *imageStr = _model.dynamicInfo.TPLY;
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    checkImageVC.dataArray = imageArrays;
    checkImageVC.page = [dic[@"tag"] intValue];
    
    [self.navigationController pushViewController:checkImageVC animated:YES];
}


#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhotoDetailCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    
    NSMutableArray *imageArrays = [NSMutableArray array];
    
    NSString *imageStr = _model.dynamicInfo.TPLY;
    
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    [photoCell setIntroductionText:_model.dynamicInfo.TPSM image:imageArrays comment:_model indexPath:indexPath.row];
    
    [photoCell setData:_model];
    
    return photoCell;
}


@end
