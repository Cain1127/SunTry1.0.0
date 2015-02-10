//
//  QSPFoodPackageItemView.m
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodPackageItemView.h"
#import "QSLabel.h"
#import "NSString+Calculation.h"
#import "DeviceSizeHeader.h"
#import "QSPFoodPackageItemGridView.h"

#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_STRING_FONT_SIZE        20.
#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_TEXT_COLOR             [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]


@interface QSPFoodPackageItemView ()

@property(nonatomic,strong) id          foodPackageData;
@property(nonatomic,strong) QSLabel     *packageNameLabel;
@property(nonatomic,strong) NSArray     *foodList;

@end

@implementation QSPFoodPackageItemView

- (instancetype)initItemViewWithData:(id)foodData
{
    self.foodPackageData = foodData;
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, 321/375.*SIZE_DEVICE_WIDTH, 0)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        //菜品类型
        NSString* packageNameStr = @"请选择主食(1份)";
        self.packageNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10, 16, self.frame.size.width, 14)];
        [self.packageNameLabel setTextColor:PACKAGE_VIEW_FOOD_PACKAGE_NAME_TEXT_COLOR];
        [self.packageNameLabel setFont:[UIFont systemFontOfSize:PACKAGE_VIEW_FOOD_PACKAGE_NAME_STRING_FONT_SIZE ]];
        [self.packageNameLabel setText:packageNameStr];
        [self addSubview:self.packageNameLabel];
        
        CGFloat buttomY = self.packageNameLabel.frame.origin.y+self.packageNameLabel.frame.size.height;
        
        self.foodList = [NSArray arrayWithObjects:@"",@"", nil];
        
        for (int i=0; i<[_foodList count]; i++) {
            
            QSPFoodPackageItemGridView *gridView = [[QSPFoodPackageItemGridView alloc] initGridViewWithData:[_foodList objectAtIndex:i]];
            [gridView setFrame:CGRectMake(self.packageNameLabel.frame.origin.x-4+(i%2)*(166/375.*SIZE_DEVICE_WIDTH), self.packageNameLabel.frame.origin.y+self.packageNameLabel.frame.size.height+12+(i/2)*(gridView.frame.size.height+12), gridView.frame.size.width, gridView.frame.size.height)];
            [self addSubview:gridView];
            
            buttomY = gridView.frame.origin.y+gridView.frame.size.height;
            
        }
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, buttomY+12)];
        
    }
    
    return self;
    
}

- (NSArray*)getSelectFoodList
{
    
    NSMutableArray *selectFoodList = [NSMutableArray arrayWithCapacity:0];

    for (QSPFoodPackageItemGridView *gridView in [self subviews]) {
        
        if ([gridView getSelectState]) {
            
            [selectFoodList addObject:[gridView getFoodData]];
            
        }
        
    }
    return selectFoodList;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
