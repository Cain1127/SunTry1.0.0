//
//  QSPAddNewAddressTextField.m
//  suntry
//
//  Created by CoolTea on 15/2/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPAddNewAddressTextField.h"

@implementation QSPAddNewAddressTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setReturnKeyType:UIReturnKeyDone];
    
        [self.layer setCornerRadius:5.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderColor:[PLACEHOLDER_TEXT_COLOR CGColor]];
        [self.layer setBorderWidth:0.5f];
    }
    
    return self;
    
}

- (void)setPlaceholder:(NSString*)str
{
    
    [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR}]];
    
}

@end
