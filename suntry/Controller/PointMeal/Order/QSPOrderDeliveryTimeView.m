//
//  QSPOrderDeliveryTimeView.m
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDeliveryTimeView.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "QSBlockButton.h"

#define ORDER_DELIVERY_VIEW_TITLE_FONT_SIZE       17.
#define ORDER_DELIVERY_VIEW_ITEM_TITLE_FONT_SIZE  15.
#define ORDER_DELIVERY_VIEW_LINE_COLOR            [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]


@interface QSPOrderDeliveryTimeView ()

@property (nonatomic,assign)DeliveryTimeType selectedTimeType;

@end

@implementation QSPOrderDeliveryTimeView

- (instancetype)initOrderDeliveryTimeView
{
    self.selectedTimeType = DeliveryTimeTypeNoSelected;
    if (self = [super init]) {
        
        QSLabel *timeTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 15, SIZE_DEVICE_WIDTH-24, 17)];
        [timeTip setFont:[UIFont boldSystemFontOfSize:ORDER_DELIVERY_VIEW_TITLE_FONT_SIZE]];
        [timeTip setText:@"送餐时间"];
        [timeTip setTextColor:[UIColor blackColor]];
        [self addSubview:timeTip];
        
        NSArray *timeList = [NSArray array];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];
        NSString *todayAMDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *todayAMDate = [dateFormatter dateFromString:todayAMDateStr];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd 18:00:00"];
        NSString *todayPMDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *todayPMDate = [dateFormatter dateFromString:todayPMDateStr];

        NSDate *currentDate = [NSDate date];
        NSComparisonResult amCompareResult = [currentDate compare: todayAMDate];
        NSComparisonResult pmCompareResult = [currentDate compare: todayPMDate];
        if (amCompareResult == NSOrderedAscending) {
            //比12点早
//            timeList = [NSArray arrayWithObjects:@"今天午餐",@"今天晚餐",@"明天午餐",@"明天晚餐", nil];
            timeList = [NSArray arrayWithObjects:@"今天午餐",@"今天晚餐", nil];
            
        }else if (pmCompareResult == NSOrderedAscending) {
            //比18点早
//            timeList = [NSArray arrayWithObjects:@"今天晚餐",@"明天午餐",@"明天晚餐", nil];
            timeList = [NSArray arrayWithObjects:@"今天晚餐", nil];
            
        }else{
//            timeList = [NSArray arrayWithObjects:@"明天午餐",@"明天晚餐", nil];
            
        }
        
        CGFloat labelWidth = 70;//标题宽度
        
        for (int i=0; i<[timeList count]; i++) {
//            CGFloat spaceWidth = (SIZE_DEVICE_WIDTH-labelWidth*[timeList count])/([timeList count]+1);//居中平均放置
            CGFloat spaceWidth = (SIZE_DEVICE_WIDTH-labelWidth*4)/5;//靠左放置
            QSLabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(spaceWidth+(labelWidth+spaceWidth)*i, timeTip.frame.origin.y+timeTip.frame.size.height+12, labelWidth, 18)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont systemFontOfSize:ORDER_DELIVERY_VIEW_ITEM_TITLE_FONT_SIZE]];
            [titleLabel setText:[timeList objectAtIndex:i]];
            [self addSubview:titleLabel];
            
            QSBlockButtonStyleModel *selectedBtStyle = [[QSBlockButtonStyleModel alloc] init];
            [selectedBtStyle setImagesNormal:@"order_payment_normal_bt"];
            [selectedBtStyle setBgColor:[UIColor clearColor]];
            UIButton *selectedBt = [UIButton createBlockButtonWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, 60) andButtonStyle:selectedBtStyle andCallBack:^(UIButton *button) {
                
                for (UIView *subView in [self subviews]) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        [(UIButton*)subView setImage:[UIImage imageNamed:@"order_payment_normal_bt"] forState:UIControlStateNormal];
                    }
                }
                
                [button setImage:[UIImage imageNamed:@"order_payment_selected_bt"] forState:UIControlStateNormal];
                
                NSString *titleStr = [timeList objectAtIndex:button.tag];
                if ([titleStr isEqualToString:@"今天午餐"]) {
                    _selectedTimeType = DeliveryTimeTypeTodayAM;
                }else if ([titleStr isEqualToString:@"今天晚餐"]) {
                    _selectedTimeType = DeliveryTimeTypeTodayPM;
                }else if ([titleStr isEqualToString:@"明天午餐"]) {
                    _selectedTimeType = DeliveryTimeTypeTomorrowAM;
                }else if ([titleStr isEqualToString:@"明天晚餐"]) {
                    _selectedTimeType = DeliveryTimeTypeTomorrowPM;
                }
                NSLog(@"选择了：%d %@",_selectedTimeType,titleStr);
                
            }];
//            [selectedBt setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
            [selectedBt setTag:i];
            [selectedBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -10, 0)];
            [self addSubview:selectedBt];
            
        }
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, timeTip.frame.origin.y+timeTip.frame.size.height+12 + 60, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDER_DELIVERY_VIEW_LINE_COLOR];
        [self addSubview:lineButtomView];
        
        CGFloat bottomY = lineButtomView.frame.origin.y+lineButtomView.frame.size.height;
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, bottomY)];
        
        if ( [timeList count] == 0 ) {
            
            self.selectedTimeType = DeliveryTimeTypeOutTime;
            
            [timeTip setHidden:YES];
            
            QSLabel *outTimeTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-24, bottomY)];
            [outTimeTipLabel setFont:[UIFont boldSystemFontOfSize:ORDER_DELIVERY_VIEW_TITLE_FONT_SIZE]];
            [outTimeTipLabel setText:@"今天送餐时间已过"];
            [outTimeTipLabel setTextAlignment:NSTextAlignmentCenter];
            [outTimeTipLabel setTextColor:[UIColor blackColor]];
            [self addSubview:outTimeTipLabel];
            
        }
        
    }
    return self;
}

- (DeliveryTimeType)getSelectedDeliveryTime
{
    return _selectedTimeType;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
