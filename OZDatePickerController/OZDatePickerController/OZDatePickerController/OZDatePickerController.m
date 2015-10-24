//
//  OZDatePickerController.m
//  CycleScrollView
//
//  Created by StanOz on 10/16/15.
//  Copyright © 2015 Quzi. All rights reserved.
//

#import "OZDatePickerController.h"
#import "OZCycleScrollView.h"

@interface OZDatePickerController () <OZCycleScrollViewDelegate, OZCycleScrollViewDataSource>
@property (strong, nonatomic) NSArray *months;
@property (weak, nonatomic) IBOutlet OZCycleScrollView *dayPickerView;
@property (weak, nonatomic) IBOutlet OZCycleScrollView *monthPickerView;
@property (weak, nonatomic) IBOutlet OZCycleScrollView *yearPickerView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign, nonatomic) NSInteger startYear;
@property (assign, nonatomic) NSInteger totalYear;
@property (assign, nonatomic) NSInteger selectedYear;
@property (assign, nonatomic) NSInteger selectedMonth;
@property (assign, nonatomic) NSInteger selectedDay;

@end

@implementation OZDatePickerController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",
                @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    _totalYear = 200;
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    _startYear = components.year - _totalYear + 1;
    _selectedMonth = components.month;
    _selectedDay = components.day;
    [_yearPickerView setSelectedIndex:_totalYear - 2];
    [_monthPickerView setSelectedIndex:_selectedMonth - 2];
    [_dayPickerView setSelectedIndex:_selectedDay - 2];
    
    _yearPickerView.delegate = self;
    _yearPickerView.dataSource = self;
    
    _monthPickerView.delegate = self;
    _monthPickerView.dataSource = self;
    
    _dayPickerView.delegate = self;
    _dayPickerView.dataSource = self;
}

#pragma mark - OZCycleScrollView Datasource
-(NSInteger)numberOfRowsInScrollview:(OZCycleScrollView *)sv {
    if (sv == _dayPickerView) {
        return [self numberOfDays];
    }
    
    if (sv == _monthPickerView) {
        return _months.count;
    }
    
    if (sv == _yearPickerView) {
        return _totalYear;
    }
    
    return 0;
}

-(UIView *)cycleScrollView:(OZCycleScrollView *)sv viewForRow:(NSInteger)index {
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = [UIColor lightTextColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:13.0];
    if (sv == _dayPickerView) {
        lab.text = [NSString stringWithFormat:@"%ld", index + 1];
        return lab;
    }
    
    if (sv == _monthPickerView) {
        lab.text = _months[index];
        return lab;
    }
    
    if (sv == _yearPickerView) {
        lab.text = [NSString stringWithFormat:@"%ld", _startYear + index];
        return lab;
    }
    return lab;
}

#pragma mark - OZCycleScrollView Delegate
-(void)cycleScrollView:(OZCycleScrollView *)sv selectedRow:(NSInteger)row {
    
    if (sv != _dayPickerView) {
        _selectedYear = _startYear + _yearPickerView.selectedIndex;
        _selectedMonth = _monthPickerView.selectedIndex + 1;
        [_dayPickerView reloadDataThenPerformSelectedRow];
    }

    if (sv == _dayPickerView) {
        _selectedDay = _dayPickerView.selectedIndex + 1;
    }

    [self delegatePerformSelectedDate];
}

-(void)cycleScrollView:(OZCycleScrollView *)sv viewWillBeSelected:(UIView *)view {
    UILabel *lab = (UILabel *)view;
    lab.textColor = [UIColor whiteColor];
}

#pragma mark - Private Helper
-(NSInteger)numberOfDays {
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.year = _selectedYear;
    component.month = _selectedMonth;
    component.day = 1;
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:component];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}

-(void)delegatePerformSelectedDate {
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", _selectedYear, _selectedMonth, _selectedDay];
    NSDate *date = [_dateFormatter dateFromString:dateStr];
    if ([date isEqualToDate:_selectedDate]) {
        return;
    }
    _selectedDate = date;
    if (_delegate && [_delegate respondsToSelector:@selector(ozDatePciker:didSelectedDate:)]) {
        [_delegate ozDatePciker:self didSelectedDate:_selectedDate];
    }
}
@end
