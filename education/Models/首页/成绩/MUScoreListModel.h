//
//  MUScoreListModel.h
//  education
//
//  Created by Apple on 15/7/20.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol MUScoreListModel <NSObject>


@end

@interface MUScoreListModel : JSONModel
@property (nonatomic,strong) NSString *KUMC;
@end
