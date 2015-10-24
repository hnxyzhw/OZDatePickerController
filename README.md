#OZDatePickerController
An iOS date picker without 3D roller effect.


##Screenshot
![](https://raw.githubusercontent.com/StanOz/OZDatePickerController/master/OZDatePickerController/OZDatePickerDemo.gif)  

##Sample
Add a pickerViewController to view first:

    OZDatePickerController *datePicker = [[OZDatePickerController alloc] init];
    datePicker.delegate = self;
    [datePicker.view setFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 200)];
    [self.view addSubview:datePicker.view];
    [self addChildViewController:datePicker];
    [datePicker didMoveToParentViewController:self];

Then implement delegate Method:
	
	-(void)ozDatePciker:(OZDatePickerController *)picker didSelectedDate:(NSDate *)date;

##License
All source code is licensed under the [MIT License](https://raw.githubusercontent.com/StanOz/OZDatePickerController/master/LICENSE).
