//
//  UploadViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface UploadViewController : UIViewController <CLLocationManagerDelegate,UIImagePickerControllerDelegate>



@property (weak, nonatomic) IBOutlet UIImageView *image_to_upload;

@property (weak, nonatomic) IBOutlet UISwitch *useMyLocationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useSavedLocationsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useCustomLocationSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *savedLocationsSwitch;

@property (weak, nonatomic) IBOutlet UITextView *description_field;

@property (weak, nonatomic) IBOutlet UITextView *title_field;

@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *provinceField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;


@property (nonatomic) BOOL presentCameraOnStartup;
@property (nonatomic , strong) CLLocationManager *locationManager;


- (IBAction)showDatePicker:(id)sender;
- (IBAction)useMyLocation:(id)sender;
- (IBAction)useSavedLocations:(id)sender;
- (IBAction)useCustomLocation:(id)sender;

- (IBAction)submitObservation:(id)sender;

- (IBAction)cancel:(id)sender;

@end
