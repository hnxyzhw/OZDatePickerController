//
//  ViewController.m
//  OZDatePickerController
//
//  Created by StanOz on 10/24/15.
//  Copyright © 2015 Stan. All rights reserved.
//

#import "ViewController.h"
#import "OZDatePickerController/OZDatePickerController.h"

@interface ViewController () <OZDatePickerDelegate>
@property (strong, nonatomic) UILabel *dateLab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 30)];
    _dateLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dateLab];
    
    OZDatePickerController *datePicker = [[OZDatePickerController alloc] init];
    datePicker.delegate = self;
    [datePicker.view setFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 200)];
    [self.view addSubview:datePicker.view];
    [self addChildViewController:datePicker];
    [datePicker didMoveToParentViewController:self];
}

#pragma mark - OZDatePickerDelegate
-(void)ozDatePciker:(OZDatePickerController *)picker didSelectedDate:(NSDate *)date {
    _dateLab.text = [NSString stringWithFormat:@"%@", date];
}
@end
