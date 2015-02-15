//
//  QSWTheSuntryView.m
//  suntry
//
//  Created by 王树朋 on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWTheSuntryView.h"
#import "DeviceSizeHeader.h"

@interface QSWTheSuntryView ()
@property(nonatomic,strong) UIImageView *suntryImage;

@end

@implementation QSWTheSuntryView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _suntryImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f-49.0f)];
    _suntryImage.image=[UIImage imageNamed:@"myinfo_thesuntry"];
    [self.view addSubview:_suntryImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
