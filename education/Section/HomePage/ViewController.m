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
#import "SETabBarViewController.h"
#import "ClassCircleViewController.h"
#import "LifeServiceViewController.h"
#import "EDPhySicalTestViewController.h"
#import "EDInfomationViewController.h"
#import "EDGradeRecodeViewController.h"
#import "GrowthTrailViewController.h"
#import "EDPrivateNoteViewController.h"
#import "EDHomeWorkViewController.h"
#import "EDSubjectViewController.h"
#import "EDNoticeViewController.h"

#define IMAGEHEIGHT (160 * ([UIScreen mainScreen].bounds.size.height/568.0))
#define USERINTROHEIGHT (64 * ([UIScreen mainScreen].bounds.size.height/568.0))
#define BUTTONVIEWHEIGHT (204 * ([UIScreen mainScreen].bounds.size.height/568.0))

@interface ViewController () {
    CGFloat scale;
    NSArray *stringArray;
    NSArray *imagesArray;
    UIView *borderView;
    UIButton *imageBtn;
    NSTimer *myTimer;
    SETabBarViewController *tabBarViewController;
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
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    
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
        
        [self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];
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
    
    
    // cell
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 6 * scale)];
    borderView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.000];

    
    imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 56 * scale, 20 * scale)];
    imageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [imageBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:6.0/255.0 alpha:1.000] forState:UIControlStateNormal];
    [imageBtn setTitle:@"最新.班级圈" forState:UIControlStateNormal];
    
    imageBtn.layer.cornerRadius = 5.0;
    imageBtn.layer.borderWidth = 1;
    imageBtn.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:6.0/255.0 alpha:1.000].CGColor;
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
    [tabBarViewController tabBarViewShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Custom Method
- (void) updateScrollView
{
    [myTimer invalidate];
    myTimer = nil;
    //time duration
    NSTimeInterval timeInterval = 5;
    //timer
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                             selector:@selector(handleMaxShowTimer:)
                                             userInfo: nil
                                              repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    // scrollView的偏移量
    CGPoint pt = _scrollView.contentOffset;
    
    NSUInteger count = [slideImages count];
    
    // 如果scrollView的横向偏移量为屏幕宽度的整数倍.
    if(pt.x == SCREENWIDTH * count){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,IMAGEHEIGHT) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(pt.x+SCREENWIDTH,0,SCREENWIDTH,IMAGEHEIGHT) animated:YES];
    }
    
    
}

- (void)schoolTimeTable {
    NSLog(@"1");
}

- (void)myLetter {
    EDPrivateNoteViewController *privateNoteVC = [[EDPrivateNoteViewController alloc]init];
    [self.navigationController pushViewController:privateNoteVC animated:YES];
}

- (void)notice {
    EDNoticeViewController  *notice = [[EDNoticeViewController alloc]init];
    [self.navigationController pushViewController:notice animated:YES];
}

- (void)classSection {
    ClassCircleViewController *classCircleVC  = [[ClassCircleViewController alloc] init];
    [self.navigationController pushViewController:classCircleVC animated:YES];
}

- (void)lifeService {
    LifeServiceViewController *lifeServiceVC = [[LifeServiceViewController alloc] init];
    [self.navigationController pushViewController:lifeServiceVC animated:YES];
}

- (void)introDay {
    EDInfomationViewController *infoVC = [[EDInfomationViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)problem {
    EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
    [self.navigationController pushViewController:subjectVC animated:YES];
}

- (void)score {
    EDGradeRecodeViewController *gradeVC = [[EDGradeRecodeViewController alloc]init];
    [self.navigationController pushViewController:gradeVC animated:YES];
}

- (void)homework {
    EDHomeWorkViewController *homeWorkVC = [[EDHomeWorkViewController alloc]init];
    [self.navigationController pushViewController:homeWorkVC animated:YES];
}

- (void)growUp {
    GrowthTrailViewController *growthTrailVC = [[GrowthTrailViewController alloc] init];
    [self.navigationController pushViewController:growthTrailVC animated:YES];
}

- (void)body {
    EDPhySicalTestViewController *physicalVC = [[EDPhySicalTestViewController alloc]init];
    [self.navigationController pushViewController:physicalVC animated:YES];
}

- (void)courseOnLine {
    NSLog(@"12");
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
    else if (indexPath.row == 3) {
        return 32 * scale;
    }
    else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height + 10;
    }
    
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4 + [stringArray count];
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.row == 2) {
        ButtonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonViewCell"];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.btn1 addTarget:self action:@selector(schoolTimeTable) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(myLetter) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(classSection) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(lifeService) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(introDay) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(problem) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(score) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(homework) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn10 addTarget:self action:@selector(growUp) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn11 addTarget:self action:@selector(body) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn12 addTarget:self action:@selector(courseOnLine) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:imageBtn];
        [cell.contentView addSubview:borderView];
        return cell;
    }
    else {
        HomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homePageListCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageListCell" owner:self options:nil] lastObject];
        }
        
        [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row] - 4] image:imagesArray reply:@[@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊a",@"范德萨范德萨范德萨范德萨大叔大叔的"] index:indexPath.row - 4];
        
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
