//
//  AppDelegate.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SETabBarViewController.h"
#import "EDContactViewController.h"
#import "MineViewController.h"
#import "EDSettingViewController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import "GuidePageViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayEndViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // 在Info.plist 配置View con....后添加下面代码即可实现状态栏白字.
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        // 使用图片给导航栏附加颜色
        // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_color"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navColor"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTranslucent:NO];
//        // 直接附加颜色
//        [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
        
        // 设置导航栏字体颜色
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    }
    
    // 防止键盘遮挡textField
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:5];
    
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        
        GuidePageViewController *guidePageViewController = [[GuidePageViewController alloc] init];
        self.window.rootViewController = guidePageViewController;
    }
    else{
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] intValue] == 9000) {
                
                NSString * resultStr =resultDic[@"result"];
                
                // 用 nil 代替 \"
                NSString *str = [resultStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                // 去除字符串中的 & 符号
                NSArray *strarray = [str componentsSeparatedByString:@"&"];
                
                NSString *order_no;
                
                for (NSString *resultkv in strarray) {
                    // 在字符串中搜索子串
                    NSRange range = [resultkv rangeOfString:@"out_trade_no"];
                    
                    if (range.length > 0) {
                        NSArray *strarray = [resultkv componentsSeparatedByString:@"="];
                        order_no = strarray[1];
                        break;
                    }
                }
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                            @"code":@"43242",
                                            @"order_num":order_no,
                                            @"status":@"2"
                                            };
                
                
                
                NSString *urlStr = [NSString stringWithFormat:@"%@SetOrder",SERVER_HOST];
                
                // 设置超时时间
                [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                manager.requestSerializer.timeoutInterval = 10.f;
                [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
                [manager POST:urlStr parameters:parameter
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          if ([responseObject[@"responseCode"] intValue] == 0) {
                              
                              PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
                              
                              UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payEndVC];
                              
                              payEndVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                              
                              AppDelegate *appd = (AppDelegate *)application.delegate;
                              [appd.window.rootViewController presentViewController:nav animated:NO completion:nil];
                              
                          }
                          else {
                              SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(error.code == -1001)
                          {
                              SHOW_ALERT(@"提示", @"网络请求超时");
                          }else if (error.code == -1009)
                          {
                              SHOW_ALERT(@"提示", @"网络连接已断开");
                          }
                      }];
            }
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] intValue] == 9000) {
                
                NSString * resultStr =resultDic[@"result"];
                
                // 用 nil 代替 \"
                NSString *str = [resultStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                // 去除字符串中的 & 符号
                NSArray *strarray = [str componentsSeparatedByString:@"&"];
                
                NSString *order_no;
                
                for (NSString *resultkv in strarray) {
                    // 在字符串中搜索子串
                    NSRange range = [resultkv rangeOfString:@"out_trade_no"];
                    
                    if (range.length > 0) {
                        NSArray *strarray = [resultkv componentsSeparatedByString:@"="];
                        order_no = strarray[1];
                        break;
                    }
                }
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                            @"code":@"43242",
                                            @"order_num":order_no,
                                            @"status":@"2"
                                            };
                
                
                
                NSString *urlStr = [NSString stringWithFormat:@"%@SetOrder",SERVER_HOST];
                
                // 设置超时时间
                [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                manager.requestSerializer.timeoutInterval = 10.f;
                [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
                [manager POST:urlStr parameters:parameter
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          if ([responseObject[@"responseCode"] intValue] == 0) {
                              
                              PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
                              
                              UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payEndVC];
                              
                              payEndVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                              
                              AppDelegate *appd = (AppDelegate *)application.delegate;
                              [appd.window.rootViewController presentViewController:nav animated:NO completion:nil];
                              
                              
                          }
                          else {
                              SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(error.code == -1001)
                          {
                              SHOW_ALERT(@"提示", @"网络请求超时");
                          }else if (error.code == -1009)
                          {
                              SHOW_ALERT(@"提示", @"网络连接已断开");
                          }
                      }];
            }
            
        }];
    }
    
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
