//
//  ViewController.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UserIntroCell.h"
#import "ButtonViewCell.h"
#import "HomePageListCell.h"

#define IMAGEHEIGHT (160 * ([UIScreen mainScreen].bounds.size.height/568.0))
#define USERINTROHEIGHT (64 * ([UIScreen mainScreen].bounds.size.height/568.0))
#define BUTTONVIEWHEIGHT (216 * ([UIScreen mainScreen].bounds.size.height/568.0))

@interface ViewController () {
    CGFloat scale;
    NSArray *stringArray;
    NSArray *imagesArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scale = SCALE;
    
    stringArray = [NSArray array];
    imagesArray = [NSArray array];
    
    stringArray = @[@"h和和哈哈哈哈哈哈",@"是是是是是是是是是是是是是是是是是呃呃呃呃呃呃呃呃呃是",@"去去去去去去去去去去去去去去去去去去去去去去去去去去去去去去去求去去去去去去去去去去去去去去去去去去去去去去求"];
    
    imagesArray = @[@"1",@"1",@"1"];
    
    slideImages = [NSMutableArray arrayWithArray:@[@"example1",@"example2",@"example3"]];
    
    // 是否设置回弹效果
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, IMAGEHEIGHT)];
    _scrollView.tag = 501;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    
    // 设置scrollView的滚动范围为图片数量+2
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*([slideImages count]+2),IMAGEHEIGHT);
    
    
    /*
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorSkip)];
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
    */
     
    // 首次显示的页面
   
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:[slideImages count]-1]]];
    imageView.frame = CGRectMake(0, 0, SCREENWIDTH, IMAGEHEIGHT);
    
    // 把最后一张图片添加到scrollView中
    [_scrollView addSubview:imageView];
    
    
    if ([slideImages count] > 1) {
        
        // 把所有页面都添加到容器中
        for (int i = 0;i<[slideImages count];i++) {
            //loop this bit
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
            imageView.frame = CGRectMake(SCREENWIDTH*i+SCREENWIDTH, 0, SCREENWIDTH, IMAGEHEIGHT);
            
            // 把所有图片一次添加到scrollView中
            [_scrollView addSubview:imageView];
        }
        
        
        imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
        imageView.frame = CGRectMake(SCREENWIDTH*([slideImages count] + 1), 0, SCREENWIDTH, IMAGEHEIGHT);
        
        // 把第一张图片添加到scrollView中
        [_scrollView addSubview:imageView];
        
        
        // 假定需要滚动的图片数量为5张，编号为1~5，则此时scrollView中对应的图片编号为5，1，2，3，4，5，1共7张.
        
        //[self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];
    }
    
    // UIPageControl页面控件
    
    // 新建page
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(320/2 - 35, IMAGEHEIGHT - 30, 70, 30)];
    
    
    _page.numberOfPages = [slideImages count];
    _page.currentPage = 0;
    
    _page.pageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:0.6];
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    
    [_page addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_page];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return IMAGEHEIGHT;
    }
    else if (indexPath.row == 1) {
        return USERINTROHEIGHT;
    }
    else if (indexPath.row == 2) {
        return BUTTONVIEWHEIGHT;
    }
    else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height + 10;
    }
    
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + [stringArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:_scrollView];
        
        return cell;
    }
    else if (indexPath.row == 1) {
        UserIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userIntroCell"];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserIntroCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.row == 2) {
        ButtonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonViewCell"];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else {
        HomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homePageListCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageListCell" owner:self options:nil] lastObject];
        }
        
        [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row] - 3] image:imagesArray reply:@[@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊a",@"范德萨范德萨范德萨范德萨大叔大叔的"] index:indexPath.row - 3];
        
        return cell;
    }
}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if (scrollView.tag == 501) {
        
        
        int currentPage = (_scrollView.contentOffset.x - _scrollView.frame.size.width / ([slideImages count])) / _scrollView.frame.size.width + 1;
        NSLog(@"%d",currentPage);
        if (currentPage==0) {
            [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH*[slideImages count], 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
        }
        else if (currentPage==([slideImages count]+1)) {
            [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender

{
    if (sender.tag == 501) {
        int page = _scrollView.contentOffset.x/SCREENWIDTH-1;
        //int page = _scrollView.contentOffset.x/320;
        _page.currentPage = page;
    }
}

-(void)pageAction
{
    int page = (int)_page.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * (page+1), 0)];
    [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * (page+1), 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
