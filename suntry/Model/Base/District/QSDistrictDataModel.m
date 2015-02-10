//
//  QSDistrictDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictDataModel.h"

@implementation QSDistrictDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"districtID", @"name" : @"val"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addAttributeMappingsFromArray:@[@"id_"]];
    
    
    // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 2.存储数据
    [defaults setObject:mappingDict forKey:@"Dictinfo"];

    
    // 3.立刻同步
    [defaults synchronize];
    
    NSString *districtID = [defaults objectForKey:@"id"];
    NSString *val = [defaults objectForKey:@"name"];
    NSLog(@"%@ -- %@", districtID,val);
    
    [defaults objectForKey:@"Dictinfo"];
    
    return shared_mapping;
    
    
}


- (IBAction)save {
    // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 2.存储数据
    [defaults setObject:@"districtID" forKey:@"id"];
    [defaults setObject:@"val" forKey:@"name"];
    
    // 3.立刻同步
    [defaults synchronize];
}

- (IBAction)read {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *districtID = [defaults objectForKey:@"id"];
    NSString *val = [defaults objectForKey:@"name"];
    NSLog(@"%@ -- %@", districtID,val);
}

@end
