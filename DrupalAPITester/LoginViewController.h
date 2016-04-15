//
//  LoginViewController.h
//  
//
//  Created by William Millington on 2016-03-05.
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
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VCUtility.h"
#import "DIOSUser.h"
#import "DIOSNode.h"
#import "DIOSView.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SWRevealViewController.h"

@interface LoginViewController : UIViewController




@property (weak, nonatomic) IBOutlet UIView *credentialsBox;
@property (weak, nonatomic) IBOutlet UITextField *username_field;
@property (weak, nonatomic) IBOutlet UITextField *password_field;
@property (weak, nonatomic) IBOutlet UILabel *wrong_credentials;


- (IBAction)login_button:(id)sender;

@end
