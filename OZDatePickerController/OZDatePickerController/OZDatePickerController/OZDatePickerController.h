//
//  OZDatePickerController.h
//  CycleScrollView
//
//  Created by StanOz on 10/16/15.
//  Copyright © 2015 Quzi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OZDatePickerDelegate;

@interface OZDatePickerController : UIViewController
@property (weak, nonatomic) id <OZDatePickerDelegate>delegate;
@property (strong, nonatomic) NSDate *selectedDate;
@end

@protocol OZDatePickerDelegate <NSObject>
-(void)ozDatePciker:(OZDatePickerController *)picker didSelectedDate:(NSDate *)date;
@end
