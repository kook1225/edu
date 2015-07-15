//
//  GradeModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface GradeModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *NJMC;
@property (strong,nonatomic) NSString<Optional> *RXNF;
@property (strong,nonatomic) NSString<Optional> *NJID;
@property (strong,nonatomic) NSString<Optional> *SFZX;

@end
