//
//  LoginViewController.m
//
//
//  Created by William Millington on 2016-03-05.
//  Modifications by Jonathan Cudmore
//
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

#import "LoginViewController.h"
#import "UserViewController.h"
#import "DIOSSession.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSDictionary *userInfo;
}

@synthesize credentialsBox;
@synthesize username_field;
@synthesize password_field;
@synthesize wrong_credentials;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style: UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Set username field to no autocorrect
    username_field.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Style the view holding the username and
    // password fields
    [credentialsBox.layer setCornerRadius:10.0f];
    [credentialsBox.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    
    
    UITapGestureRecognizer * hideKeyboardGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:hideKeyboardGesture];
}


-(void)hideKeyBoard {
    if([password_field isFirstResponder]){
        [password_field resignFirstResponder];
    }
    else if(username_field){
        [username_field resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// Log in the user and set up user defaults.
// User defaults will allow the user to be logged in  until
// they specifically request to log out from the user profile
// view even after the app closes
- (IBAction)login_button:(id)sender {
    
    if([username_field.text isEqualToString:@""] || [password_field.text isEqualToString:@""]) {
        [wrong_credentials setHidden:FALSE];
        return;
    }
    
    
    [DIOSUser userLoginWithUsername:username_field.text
                        andPassword:password_field.text
                            success:^(AFHTTPRequestOperation *op, id response) {
                                // Hide the wrong credentials if it was showing
                                // from a previous attempt
                                [wrong_credentials setHidden:TRUE];
                                
                                // Get CSRFToken and set up user defaults
                                [[DIOSSession sharedSession] getCSRFTokenWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    // responseObject is csrfToken represented as NSData, should be converted to string
                                    NSString *csrfToken =[ NSString stringWithCString:[responseObject bytes] encoding:NSUTF8StringEncoding];
                                    
                                    // Get user Id from userDidLoginWithUsername AFHTTPRequestOperation
                                    NSString *userId = [self getUserValuesFromAFHTTPRequestOperationWithKey:@"uid" fromRequestOperation:op.responseString];
                                    
                                    // Get user information from server
                                    [self fetchUserInfoForId:userId];
                                    
                                    NSDictionary *l1Address;
                                    NSDictionary *l2Address;
                                    NSDictionary *imageDict = userInfo[@"picture"];
                                    
                                    NSDictionary *und1 = userInfo[@"field_l1_address"];
                                    NSArray *l1;
                                    if([und1 count] > 0) {
                                        l1= und1[@"und"];
                                        l1Address = l1[0];
                                    }
                                    
                                    NSDictionary *und2 = userInfo[@"field_l2_address"];
                                    NSArray *l2;
                                    if([und2 count] > 0) {
                                        l2 = und2[@"und"];
                                        l2Address = l2[0];
                                    }
                                    
                                    
                                    // Set user defaults for use outside of this class, user will stay logged in until they are logged out
                                    // or until
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:csrfToken forKey:@"token"];
                                    [defaults setValue:userId forKey:@"uid"];
                                    [defaults setValue:username_field.text forKey:@"userName"];
                                    [defaults setValue:userInfo[@"mail"] forKey:@"emailAddress"];
                                    [defaults setValue:userInfo[@"created"] forKey:@"userCreatedDate"];
                                    [defaults setValue:imageDict[@"url"] forKey:@"imageUrl"];
                                    
                                    // Save address 1 if available
                                    if([l1Address count] > 0) {
                                        [defaults setValue:l1Address[@"country"] forKey:@"l1Country"];
                                        [defaults setValue:l1Address[@"administrative_area"] forKey:@"l1Province"];
                                        [defaults setValue:l1Address[@"locality"] forKey:@"l1City"];
                                        [defaults setValue:l1Address[@"thoroughfare"] forKey:@"l1AddressLine1"];
                                        [defaults setValue:l1Address[@"premise"] forKey:@"l1AddressLine2"];
                                        [defaults setValue:l1Address[@"postal_code"] forKey:@"l1PostalCode"];
                                    }
                                    
                                    // Save address 2 if available
                                   if([l2Address count] > 0) {
                                        [defaults setValue:l2Address[@"country"] forKey:@"l2Country"];
                                        [defaults setValue:l2Address[@"administrative_area"] forKey:@"l2Province"];
                                        [defaults setValue:l2Address[@"locality"] forKey:@"l2City"];
                                        [defaults setValue:l2Address[@"thoroughfare"] forKey:@"l2AddressLine1"];
                                        [defaults setValue:l2Address[@"premise"] forKey:@"l2AddressLine2"];
                                        [defaults setValue:l2Address[@"postal_code"] forKey:@"l2PostalCode"];
                                    }
                                    
                                    
                                    // Set isLoggedIn
                                    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"isLoggedIn"];
                                    
                                    
                                    
                                    [defaults synchronize];
                                    
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    UIViewController *userAccountViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
                                    
                                    // create UINavigationController to house it
                                    UINavigationController *destinationViewController = [[UINavigationController alloc] initWithRootViewController:userAccountViewController];
                                    
                                    // swap new view controller into the FrontViewController
                                    [self.revealViewController setFrontViewController:destinationViewController animated:YES];
                                    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
                                }
                                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                                                                 NSLog(@"Could not retrieve the CSRFToken");
                                                                             }
                                 ];
                            }
                            // Login failure
                            failure:^(AFHTTPRequestOperation *op, NSError *err) {
                                // Show label informing the user of the error
                                password_field.text = @"";
                                [wrong_credentials setHidden:FALSE];
                            }
     ];
}


// Navigate to the registration page
-(IBAction)register_button:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *userAccountViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    // create UINavigationController to house it
    UINavigationController *destinationViewController = [[UINavigationController alloc] initWithRootViewController:userAccountViewController];
    
    // swap new view controller into the FrontViewController
    [self.revealViewController setFrontViewController:destinationViewController animated:YES];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
}


// Get user value from AFHTTPRequests
//
// returns the value from the request operation for the specified operation key
-(NSString *) getUserValuesFromAFHTTPRequestOperationWithKey:(NSString *) operationKey fromRequestOperation:(NSString *) request {
    
    // Find the first occurence of the operationKey
    NSRange locationOfSubstring = [request rangeOfString:operationKey];
    int startIndex = locationOfSubstring.location;
    
    // - Clip the string starting from the location of the key removing ":" (+3)
    // - Clip the key in the process in the process (+ key length)
    // Store the location of the first comma following the value
    NSString *tailString = [request substringFromIndex:(startIndex + 3) + (operationKey.length)];
    NSRange endIndex = [tailString rangeOfString:@","];
    
    
    // - Clip everything from the string following the comma
    // - (-1) clips off the closing quotation around the value
    NSString *valueRequested = [tailString substringToIndex:endIndex.location-1];
    
    return valueRequested;
}


// Fetch user information from services view */mobile-api/user/'uid'
- (void)fetchUserInfoForId:(NSString *)uid {
    // Set up URL for one-time request to Newest Observations
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://137.149.157.10/cs482/mobile-api/user/%@", uid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    // Set Request to GET, and specify JSON
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    // Set up error and response objects
    NSError *requestError = nil;
    NSURLResponse *response = nil;
    
    // Send request
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    // Convert data into JSON
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // load into userInfo dictionary
    userInfo = jsonDictionary;
}


@end
