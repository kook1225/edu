//
//  PracticeFieldImageViewController.m
//  gaoqiutong
//
//  Created by zhu jun on 14-11-10.
//  Copyright (c) 2014年 sportsexp. All rights reserved.
//

#import "CheckImageViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "SETabBarViewController.h"
#import "VIPhotoView.h"
#import <UIImageView+WebCache.h>

@interface CheckImageViewController ()<UIScrollViewDelegate> {
    int currentPage;
    SETabBarViewController *tabBarViewController;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *imageNum;

@end

@implementation CheckImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    currentPage = _page + 1;
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%lu",currentPage,(unsigned long)[_dataArray count]]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, 1)];
    _imageNum.attributedText = str;
    
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;

    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*[_dataArray count],0);
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadImage:@""];
    
    _scrollView.contentOffset = CGPointMake(SCREENWIDTH * _page, 0);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"black_nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadImage:@"icon_default"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navColor"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Custom Method
- (void)backBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadImage:(NSString *)default_image {
    for (int i = 0;i<[_dataArray count];i++) {
        //loop this bit
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,_dataArray[i]];
        NSURL *url = [NSURL URLWithString:urlStr];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:default_image]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //UIImage *image = imageView.image;
        
        VIPhotoView *photoView;
        
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, 400) andImage:imageView.image];
            
            //imageView.frame = CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, 400);
        }
        else {
            photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, 400) andImage:imageView.image];
            //imageView.frame = CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, _scrollView.frame.size.height);
        }
        photoView.autoresizingMask = (1 << 6) -1;
        
        //imageView.userInteractionEnabled = YES;
        
        [_scrollView addSubview:photoView];
        
    }

}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{

    currentPage = (_scrollView.contentOffset.x - _scrollView.frame.size.width / ([_dataArray count])) / _scrollView.frame.size.width + 1;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%lu",currentPage + 1,(unsigned long)[_dataArray count]]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, 1)];
    _imageNum.attributedText = str;
    
    
    //PhotoAlbumModel *model = _dataArray[currentPage];
    //_textView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
