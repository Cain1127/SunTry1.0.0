//
//  QSDatePickerViewController.m
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSDatePickerViewController.h"

@interface QSDatePickerViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _selectedRow;
    NSString *_selectedItem;
}
@end

@implementation QSDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.pickerType == kPickerType_DateAndTime){
        self.picker.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else if (self.pickerType == kPickerType_Date){
        self.picker.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = UIDatePickerModeDate;

    }
    else if (self.pickerType == kPickerType_Time){
        self.picker.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = UIDatePickerModeTime;

    }
    else if (self.pickerType == kPickerType_Item){
        self.picker.hidden = NO;
        self.datePicker.hidden = YES;
        _selectedRow = self.currentRow;
        _selectedItem = self.dataSource[self.currentRow];
        [self.picker selectRow:self.currentRow inComponent:0 animated:NO];
    }
    
    [self.dateCancelButton addTarget:self action:@selector(onCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateConfirmButton addTarget:self action:@selector(onConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dateCancelButton.layer setCornerRadius:5];
    [self.dateConfirmButton.layer setCornerRadius:5];
    [self.view.layer setCornerRadius:5];
}


- (IBAction)onCancelButtonAction:(id)sender
{
    if (self.onCancelButtonHandler) {
        self.onCancelButtonHandler();
    }
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.pickerType == kPickerType_DateAndTime) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        if (self.onDateConfirmButtonHandler) {
            self.onDateConfirmButtonHandler([self.datePicker date],[formatter stringFromDate:[self.datePicker date]]);
        }
    }
    else if (self.pickerType == kPickerType_Date){
        [formatter setDateFormat:@"yyyy-MM-dd"];
        if (self.onDateConfirmButtonHandler) {
            self.onDateConfirmButtonHandler([self.datePicker date],[formatter stringFromDate:[self.datePicker date]]);
        }
        
    }
    else if (self.pickerType == kPickerType_Time){
        [formatter setDateFormat:@"HH:mm"];
        if (self.onDateConfirmButtonHandler) {
            self.onDateConfirmButtonHandler([self.datePicker date],[formatter stringFromDate:[self.datePicker date]]);
        }
        
    } else if (self.pickerType == kPickerType_Item){
        
        if (self.onItemConfirmButtonHandler){
            
            self.onItemConfirmButtonHandler(_selectedRow, _selectedItem);
            
        }
        
    }

}

#pragma mark UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.dataSource[row];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.dataSource.count;
    
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    _selectedRow = row;
    _selectedItem = self.dataSource[row];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

@end
