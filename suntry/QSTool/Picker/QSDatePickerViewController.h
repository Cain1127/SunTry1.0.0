//
//  QSDatePickerViewController.h
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kPickerType_DateAndTime,
    kPickerType_Date,
    kPickerType_Time,
    kPickerType_Item
    
}kPickerType;

@interface QSDatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *dateCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *dateConfirmButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, unsafe_unretained) NSInteger currentRow;

@property (nonatomic, unsafe_unretained) kPickerType pickerType;

@property (nonatomic, strong) void(^onCancelButtonHandler)();
@property (nonatomic, strong) void(^onDateConfirmButtonHandler)(NSDate *, NSString *);
@property (nonatomic, strong) void(^onItemConfirmButtonHandler)(NSInteger, NSString *);


@end
