//
//  BPushClass.m
//  BPush
//
//  Created by wangweixin on 14-5-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BPush.h"
#import "GzipCompressor.h"
#import "JSONKit.h"
#import "OpenUDID.h"
#import "BPushClass.h"

@implementation BPushClass

+ (Class)Base64
{
    return [BPush class];
}

+ (Class) GzipCompressor
{
    return [GzipCompressor class];
}

+ (Class) OpenUDID
{
    return [OpenUDID class];
}

@end
