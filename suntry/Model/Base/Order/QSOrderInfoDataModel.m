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

    return @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOLSLk+0bc1d1BwzD/1lyxMYkQr0U6Adu2yo+yTQqYTBDr15ueqv3jX6DVP8CnmbZ+wqjvLuwcL15a65T0onLmtH48eKofgKBqoYRg4zilOsOe7190SH3OuoeoG6MoCJ9PLM2UX+NOSklad27asSr/Gk+XIGu8qHHh1L5ZdzOx7ZAgMBAAECgYAKdYKpLjq584+qVThxiNYaZVGa3bVVdsmDsy8RfYWzl2tklU5bYgyvFH601rRs8xuRqky5KwVIRip3Khhb5P6g4YuThaWd3yldWx9RRFipannsdXbXVi+qIpBGOGydgKJCTauvFES/bGyVp1L9tFL0EWduCXzFZm+3j5Ic0MYsAQJBAPtVb8y43hLb+0PDqSSYcsl9tdT0BdAsmPZhomiiCFgGuHVPAswH1pu6q9qPmQuI5VNU66Bt1qXhlsYYlFx6TRkCQQDnCDzeg1F4gImD+c5MnwzW7naDKylIdi7th8de4MhldKvctWby03SbPLvqP3ynX0OFXA8MGjP9RCZZm9ioX9fBAkAsUDUFEHc/NgAIQ6A37pUWh46evGOl/6b8kdxTvHXiJ1UwgbzJgnxJOtGAGJ9wVDOyzJ86ywL0fmDaDo1h/MJJAkEAlqzCtgRDACokhZRIPaSFhS+kz0s4829Qj8278176k2CSLbGJYNkT9aKYk9+v9qCksrclgSkduxHVSR/hH37SgQJBAI7RQH7YgpTfJKaGDcXkJg+gs1HPt0Rxr2CDsj7ZouCv9aKgU+BtURm5M3GtljA7yM5SUjKcC0ViLRNtv1eXc1U=";

}

///服务端的回调地址
- (NSString *)notify_url
{

    return [NSString stringWithFormat:@"%@AppAliPay/NotifyUrl",REQUEST_ROOT_URL];

}

@end
