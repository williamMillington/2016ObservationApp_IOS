//
//  UserViewController.h
//  DrupalAPITester
//
//  Created by Jonathan Cudmore on 2016-03-30.
//  Copyright © 2016 William Millington. All rights reserved.
//

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
