//
//  EDClassOnlinePlayerViewController.m
//  education
//
//  Created by Apple on 15/7/28.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDClassOnlinePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface EDClassOnlinePlayerViewController ()

@end

@implementation EDClassOnlinePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];

}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)playMovie:(NSString *)fileName movieType:(NSString *)type
{
    //视频文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    //视频URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
   
    movie.controlStyle = MPMovieControlStyleFullscreen;
    [movie.view setFrame:self.view.bounds];
    movie.initialPlaybackTime = -1;
    [self.view addSubview:movie.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [movie play];
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
   
}
@end
