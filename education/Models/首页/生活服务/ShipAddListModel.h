//
//  ShipAddListModel.h
//  education
//
//  Created by zhujun on 15/7/23.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface ShipAddListModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *yhm;
@property (nonatomic,strong) NSString<Optional> *id;
@property (nonatomic,strong) NSString<Optional> *member_id;
@property (nonatomic,strong) NSString<Optional> *contact;
@property (nonatomic,strong) NSString<Optional> *tel;
@property (nonatomic,strong) NSString<Optional> *province;
@property (nonatomic,strong) NSString<Optional> *city;
@property (nonatomic,strong) NSString<Optional> *district;
@property (nonatomic,strong) NSString<Optional> *address;
@property (nonatomic,strong) NSString<Optional> *zip_code;
@property (nonatomic,strong) NSString<Optional> *is_default;

@end
