//
//  CityModel.h
//  education
//
//  Created by zhujun on 15/7/23.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface CityModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *CityID;
@property (nonatomic,strong) NSString<Optional> *CityName;

@end
