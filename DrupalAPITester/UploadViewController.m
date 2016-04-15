//
//  UploadViewController.m
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

#import "UploadViewController.h"

#import "DIOSNode.h"
#import "DIOSUser.h"
#import "DIOSSession.h"
#import "DIOSFile.h"

@interface UploadViewController ()
{
    NSMutableDictionary *observation;
    UIImagePickerController *ipc;
    
}

@end

@implementation UploadViewController {
    
    UIScrollView *scrollView;
    
    BOOL datePickerVisible;
    UIDatePicker *datePicker;
    UIVisualEffectView *datePanel;
    
    NSDate *date;
    CLLocation *currentLocation;
    NSDictionary *locationSaved;
    NSDictionary *locationCustom;
    NSString *description;
    NSString *name;
    NSString *contentType;
    NSString *record;
    UIImage *observation_image;
    int imageFileID;
    
    
    UIView *imageViewPickerOverlay;
    BOOL imageViewPickerOverlayToggled;
    UIButton *chooseCamera;
    UIButton *chooseGallery;
}


@synthesize locationManager;
@synthesize presentCameraOnStartup;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up location manager to capture current location
    // ------------------------------------------------------------------------------------
    locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // Set observation variables
    // ------------------------------------------------------------------------------------
    date = [NSDate date];
    currentLocation = [locationManager location];
    locationSaved = @{};
    locationCustom = @{};
    description = [_description_field text];
    name = @"";
    contentType = @"";
    record = @"";
    imageFileID = -1;
    observation_image = [[UIImage alloc] init];
    
    
    // grab and set CSRF Token
    // ------------------------------------------------------------------------------------
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [DIOSSession sharedSession].csrfToken = [defaults objectForKey:@"token"];
    
    
    // Create panel with blur effect to
    // hold date picker
    // ------------------------------------------------------------------------------------
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    datePanel = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    
    // Capture screen size
    // ------------------------------------------------------------------------------------
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screen.size;
    double pickerHeight = 250.0f;
    
    // Set datebutton as the time RIGHT NOW
    // ------------------------------------------------------------------------------------
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    
    // Place below screen
    // ------------------------------------------------------------------------------------
    datePanel.frame = CGRectMake(0,
                                 screenSize.height,
                                 screenSize.width,
                                 pickerHeight);
    
    // Create date picker
    // ------------------------------------------------------------------------------------
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0,
                                  0,
                                  datePanel.frame.size.width,
                                  datePanel.frame.size.height);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self
                   action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    datePickerVisible = FALSE;
    
    
    // Datepicker is dismissed by tap outside
    // ------------------------------------------------------------------------------------
    [datePicker addTarget : self
                   action : @selector(dismissDatePicker:)
         forControlEvents : UIControlEventTouchUpOutside];
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(dismissDatePicker:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    
    // add datepicker to panel, and panel to self
    // ------------------------------------------------------------------------------------
    [datePanel addSubview:datePicker];
    [self.view addSubview: datePanel];
    
    
    // Provide scrollview with size constraints so autolayout
    // will work
    // ------------------------------------------------------------------------------------
    scrollView = [[self.view subviews] objectAtIndex:0];
    int screenWidth = self.view.frame.size.width;
    int screenHeight = self.view.frame.size.height;
    scrollView.contentSize = CGSizeMake(screenWidth,screenHeight+700);
    
    
    // Set location choice switches to OFF
    // ------------------------------------------------------------------------------------
    [_useSavedLocationsSwitch setOn:NO animated:NO];
    [_useCustomLocationSwitch setOn:NO animated:NO];
    
    
    // Configure the cancel button on the leftside
    // ------------------------------------------------------------------------------------
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:
                                      UIBarButtonItemStylePlain target:self
                                                                action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    
    
    // Configure ImageView to allow user to change it on tap
    // ------------------------------------------------------------------------------------
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(toggleChooseOverlay:)];
    imageViewTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *imageOverlayTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(toggleChooseOverlay:)];
    imageViewTap.numberOfTapsRequired = 1;
    
    [_image_to_upload setUserInteractionEnabled:YES];
    [_image_to_upload addGestureRecognizer:imageViewTap];
    
    
    
    CGRect imageViewPickerOverlay_frame = CGRectMake(0, 0,
                                                     _image_to_upload.frame.size.width,
                                                     _image_to_upload.frame.size.height);
    imageViewPickerOverlay = [[UIView alloc] initWithFrame:imageViewPickerOverlay_frame];
    [imageViewPickerOverlay addGestureRecognizer:imageOverlayTap];
    
    imageViewPickerOverlay.backgroundColor = [UIColor blackColor];
    imageViewPickerOverlay.alpha = 0.0;
    imageViewPickerOverlayToggled = NO;
    
    [_image_to_upload addSubview:imageViewPickerOverlay];
    
    
    // Initliaze & style "Take Picture" button
    // ----------------------------------------------------------------------------
    chooseCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseCamera.showsTouchWhenHighlighted = YES;
    
    
    chooseCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    chooseCamera.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseCamera.titleLabel.font = [UIFont systemFontOfSize:20];
    [chooseCamera setTitle:@"Take Picture" forState:UIControlStateNormal];
    [chooseCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    chooseCamera.layer.cornerRadius = 25.0;
    chooseCamera.clipsToBounds = YES;
    chooseCamera.layer.borderWidth = 1.5;
    chooseCamera.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // set position
    double cameraButton_width = 100;
    double cameraButton_height = 100;
    chooseCamera.frame = CGRectMake(imageViewPickerOverlay.frame.origin.x + 25,
                                    (imageViewPickerOverlay.frame.size.height /2 ) - cameraButton_height,
                                    cameraButton_width,
                                    cameraButton_height
                                    );
    [chooseCamera setBackgroundColor: [UIColor clearColor]];
    [chooseCamera addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageViewPickerOverlay addSubview:chooseCamera];
    
    
    
    // Initliaze & style "Choose from Gallery" button
    // ----------------------------------------------------------------------------
    chooseGallery = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseGallery.showsTouchWhenHighlighted = YES;
    
    chooseGallery.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    chooseGallery.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseGallery.titleLabel.font = [UIFont systemFontOfSize:20];
    [chooseGallery setTitle:@"Choose from Gallery" forState:UIControlStateNormal];
    [chooseGallery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    chooseGallery.layer.cornerRadius = 25.0;
    chooseGallery.clipsToBounds = YES;
    chooseGallery.layer.borderWidth = 1.5;
    chooseGallery.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // set position
    double galleryButton_width = 100;
    double galleryButton_height = 100;
    chooseGallery.frame = CGRectMake(imageViewPickerOverlay.frame.size.width - galleryButton_width - 25,
                                    (imageViewPickerOverlay.frame.size.height /2 ) - galleryButton_height,
                                    galleryButton_width,
                                    galleryButton_height
                                    );
    [chooseGallery setBackgroundColor: [UIColor clearColor]];
    [chooseGallery addTarget:self action:@selector(openGallery:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageViewPickerOverlay addSubview:chooseGallery];
    
    
    // Initialize image picker
    // ---------------------------------------------------------------------------------------
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// Intended to allow the selection of one location option
// to deselect the other options programatically in these methods.
// Left unimplemented due to time contraints
- (IBAction)useMyLocation:(id)sender {}
- (IBAction)useSavedLocations:(id)sender {}
- (IBAction)useCustomLocation:(id)sender {}



// Separates the image upload from the rest of the upload,as the
// image upload must occur first in order to imclude the image ID
// in the upload fields
- (IBAction)submitObservation:(id)sender {
    
    if(_image_to_upload.image == nil){
        [self uploadObservation];
    }
    else{
        [self uploadImage];
    }
}


- (void) uploadImage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    // encode the image for HTTP POST
    NSData *imageData = UIImageJPEGRepresentation(_image_to_upload.image, 1.0);
    NSString *base64Image = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // Set image data in file parameters
    NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
    [file setObject:base64Image forKey:@"file"];
    
    // Set Timestamp
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [file setObject:timestamp forKey:@"timestamp"];
    
    
    // Create unique filename as "observation_entry_username_timestamp"
    // Create unique filepath as "public://filename"
    // Set file name
    // Set file path
    NSString *username = [defaults objectForKey:@"userName"]; //get username
    NSString *filename = [NSString stringWithFormat:@"observation_entry_image_%@_%@.jpg",username,timestamp];
    NSString *filepath = [NSString stringWithFormat:@"public://%@",filename];
    [file setObject:filepath forKey:@"filepath"];
    [file setObject:filename forKey:@"filename"];
    
    // Set file size
    NSString *fileSize = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    [file setObject:fileSize forKey:@"filesize"];

    // Set user ID associated with image
    NSString *uid = [defaults objectForKey:@"uid"];
    [file setObject:uid forKey:@"uid"];
    
    
    [DIOSFile fileSave:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // If iamge upload is successful, continue on with the rest of the observation upload
        imageFileID = [responseObject[@"fid"] intValue];
        [self uploadObservation];
    }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Something went wrong with the upload");
               }
     ];
}


//
// The data-wrapping required by the Drupal site consists of:
//
//      Key-Value pair with the Key "und"
//          Array of length 1
//              Key-Value pair describing the data
//
// Someimes this is not required, as is the case with "type", and "field_comments"
- (void) uploadObservation{
    
    NSMutableDictionary *nodeParameters = [NSMutableDictionary new];
    
    
    // Wrap observation title
    NSString *title = [_title_field text];
    NSDictionary *title_field = @{  // NSDictionary with Key "und"
                                  @"und" : @[   // Array of length 1
                                                @{  // NSDictionary containing data
                                                    @"value" : title
                                                    }
                                                ]
                                  };
    // Save to parameters
    [nodeParameters setObject:title_field forKey:@"title_field"];
    
    
    // Specify node type as observation
    [nodeParameters setObject:@"climate_diary_entry" forKey:@"type"];
    
    
    // observation description
    [nodeParameters setObject:description forKey:@"field_comments"];
    
    
    // Wrap observation date
    NSDateComponents *dateData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                 fromDate:date];
    
    NSDictionary *date_field = @{
                                 @"und" : @[
                                            @{
                                                 @"value" : @{
                                                            @"year"     : [NSString stringWithFormat:@"%ld",(long)[dateData year]],
                                                            @"month"    : [NSString stringWithFormat:@"%ld",(long)[dateData month]],
                                                            @"day"      : [NSString stringWithFormat:@"%ld",(long)[dateData day]]
                                                              }
                                                 }
                                            ]
                                   };
    // Save to parameters
    [nodeParameters setObject:date_field forKey:@"field_date_observed"];
    
    
    // Wrap location data
    NSDictionary *currLocation_field = @{
                                           @"und" : @[
                                                        @{
                                                          @"geom" :
                                                            @{
                                                                    @"lat"  : [NSString stringWithFormat:@"%f",[currentLocation coordinate].latitude],
                                                                    @"long" : [NSString stringWithFormat:@"%f",[currentLocation coordinate].longitude]
                                                                }
                                                          }
                                                   ]
                                           };
    // Save to parameters
    [nodeParameters setObject:currLocation_field forKey:@"field_location_lat_long"];
    
    
    // Wrap the image_fid
    NSDictionary *image_fid = @{
                                @"und" : @[
                                            @{
                                                @"fid" :[NSString stringWithFormat:@"%d",imageFileID]
                                                }
                                            ]
                                };
    // Save to parameters
    [nodeParameters setObject:image_fid forKey:@"field_image"];
    
    
    [DIOSNode nodeSave:nodeParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }
    ];
    
}


// Called by datepicker when its data changes
-(void) dateChanged:(id)sender{
    date = [datePicker date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}


// Called by Cancel Button
// Dismiss self (UploadView)
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)showDatePicker:(id)sender {
    if(!datePickerVisible){
        // Set the date picker's new frame coordinates to be just
        // at the bottom of the screen
        CGRect newDatePickerFrame = datePanel.frame;
        newDatePickerFrame.origin.y = (datePanel.frame.origin.y - datePanel.frame.size.height);
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Assign new coordinates to datepicker
        datePanel.frame = newDatePickerFrame;
        
        // Begin animation
        [UIView commitAnimations];
        
        datePickerVisible = TRUE;
    }
    else {
        [self dismissDatePicker:nil];
    }
}


-(void) dismissDatePicker:(UIGestureRecognizer *)gestureRecognizer{
    if(datePickerVisible){
        // Set the date picker's new frame coordinates to be just
        // below the bottom of the screen
        CGRect newDatePickerFrame = datePanel.frame;
        newDatePickerFrame.origin.y = (datePanel.frame.origin.y + datePanel.frame.size.height);
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
        // Assign new coordinates to date picker
        datePanel.frame = newDatePickerFrame;
    
        // Begin animation
        [UIView commitAnimations];
        datePickerVisible = FALSE;
    }
}


// location manager fail
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// update current location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
}

// update To location
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    currentLocation = newLocation;
}


#pragma mark - ImagePickerController Delegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info  {
    
    // Dismiss imagePicker and get image
    [picker dismissViewControllerAnimated:YES completion:nil];
    observation_image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _image_to_upload.image = observation_image;
}

// Dismiss imagePicker if cancelled
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// Toggle the overlay to allow user to choose new photo to upload
- (void) toggleChooseOverlay:(UITapGestureRecognizer*)sender {
    if(!imageViewPickerOverlayToggled){
        imageViewPickerOverlay.alpha = 0.7;
        imageViewPickerOverlayToggled = YES;
        
    }
    else {
        imageViewPickerOverlay.alpha = 0.0;
        imageViewPickerOverlayToggled = NO;
    }
}


// If user chooses to take a new picture with the camera
- (void) openCamera:(UIButton *)sender{
    
    // check if camera is available
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"No Camera Available"
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil,
                                      nil];
        [noCameraAlert show];
        noCameraAlert = nil;
    }
    
    
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
    
    // hide overlay for when the user is returned to the upload view
    imageViewPickerOverlay.alpha = 0.0;
    imageViewPickerOverlayToggled = NO;
}

// If the user chooses to select a new picture from the gallery
- (void) openGallery:(UIButton *)sender{
    
    
    // check if photo library is available
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
    }
    else {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"No Library Available"
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil,
                                      nil];
        [noCameraAlert show];
        noCameraAlert = nil;
    }
    
    // hide overlay for when the user is returned to the upload view
    imageViewPickerOverlay.alpha = 0.0;
    imageViewPickerOverlayToggled = NO;
}

@end
