//
//  QSSearchHistoryDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSearchHistoryDataModel.h"

@implementation QSSearchHistoryDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.key forKey:@"key"];
    
}

@end
