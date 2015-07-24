//
//  SchoolTimeTableModel.h
//  education
//
//  Created by zhujun on 15/7/24.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface SchoolTimeTableModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *BJID;
@property (strong,nonatomic) NSString<Optional> *NJID;
@property (strong,nonatomic) NSString<Optional> *ZCXQ;
@property (strong,nonatomic) NSString<Optional> *QYMC;
@property (strong,nonatomic) NSString<Optional> *KC01;
@property (strong,nonatomic) NSString<Optional> *KC02;
@property (strong,nonatomic) NSString<Optional> *KC03;
@property (strong,nonatomic) NSString<Optional> *KC04;
@property (strong,nonatomic) NSString<Optional> *KC05;
@property (strong,nonatomic) NSString<Optional> *KC06;
@property (strong,nonatomic) NSString<Optional> *KC07;
@property (strong,nonatomic) NSString<Optional> *KC08;
@property (strong,nonatomic) NSString<Optional> *KC09;
@property (strong,nonatomic) NSString<Optional> *KC010;
@property (strong,nonatomic) NSString<Optional> *KBXQ;
@property (strong,nonatomic) NSString<Optional> *SFDQ;

@end
