//
//  ViewController.h
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *slideImages;
    UIPageControl *_page;
}


@end

