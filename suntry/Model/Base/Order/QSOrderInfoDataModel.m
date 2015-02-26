//
//  QSOrderInfoDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderInfoDataModel.h"

@implementation QSOrderInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"bill_id" : @"bill_id",
                                  @"order_id" : @"order_id",
                                  @"bill_num" : @"bill_num",
                                  @"order_num" : @"order_num"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

///商户进帐账号ID
- (NSString *)seller_id
{

    return @"2088511938856943";

}

///合作商户ID
- (NSString *)partner_id
{

    return @"2088511938856943";

}

///私钥
- (NSString *)priPKCS8Key
{

    return @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDi0i5PtG3NXdQcMw/9ZcsTGJEK9FOgHbtsqPsk0KmEwQ69ebnqr941+g1T/Ap5m2fsKo7y7sHC9eWuuU9KJy5rR+PHiqH4CgaqGEYOM4pTrDnu9fdEh9zrqHqBujKAifTyzNlF/jTkpJWndu2rEq/xpPlyBrvKhx4dS+WXczse2QIDAQAB";

}

///服务端的回调地址
- (NSString *)notify_url
{

    return [NSString stringWithFormat:@"%@AppAliPay/NotifyUrl",REQUEST_ROOT_URL];

}

@end
