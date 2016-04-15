//
//  UploadViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//
// This file is part of DrupalAPITester.
//
// DrupalAPITester is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Foobar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
// ---------------------------------------------------------------------------------
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
