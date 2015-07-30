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
-(void)openmovie:(NSString *)file
{
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:file]];
    
    [movie.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:movie];
    [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [movie.view setBackgroundColor:[UIColor clearColor]];
    
    [movie.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                           selector:@selector(movieFinishedCallback:)
     
                                               name:MPMoviePlayerPlaybackDidFinishNotification
     
                                             object:movie.moviePlayer];
    
}
-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
     
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}
@end
