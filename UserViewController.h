//
//  UserViewController.h
//  DrupalAPITester
//
/**	 ObservationApp, Copyright 2016, University of Prince Edward Island,
 *    550 University Avenue, C1A4P3,
 *    Charlottetown, PE, Canada
 *
 * 	 @author Jonathan Cudmore<jrcudmore@upei.ca>
 *
 *   This file is part of ObservationApp.
 *
 *   ObservationApp is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Observation App.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>


@interface UserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UILabel *location1;
@property (weak, nonatomic) IBOutlet UILabel *location2;

@property (weak, nonatomic) IBOutlet UILabel *countryL1;
@property (weak, nonatomic) IBOutlet UILabel *firstAddressL1;
@property (weak, nonatomic) IBOutlet UILabel *secondAddressL1;
@property (weak, nonatomic) IBOutlet UILabel *provinceL1;
@property (weak, nonatomic) IBOutlet UILabel *postalCodeL1;
@property (weak, nonatomic) IBOutlet UILabel *cityL1;

@property (weak, nonatomic) IBOutlet UILabel *countryL2;
@property (weak, nonatomic) IBOutlet UILabel *firstAddressL2;
@property (weak, nonatomic) IBOutlet UILabel *secondAddressL2;
@property (weak, nonatomic) IBOutlet UILabel *provinceL2;
@property (weak, nonatomic) IBOutlet UILabel *postalCodeL2;
@property (weak, nonatomic) IBOutlet UILabel *cityL2;

@end
