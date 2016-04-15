//
//  UserRegisterViewController.m
//  ObservationApp
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

#import "UserRegisterViewController.h"
#import "SWRevealViewController.h"
#import "DIOSSession.h"
#import "DIOSUser.h"

@interface UserRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UISwitch *agreeSwitch;
@property (weak, nonatomic) IBOutlet UIWebView *termsPage;

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    // TODO: Update to hold final terms and conditions
    NSString *urlString = @"http://creativecommons.org/licenses/by/4.0/legalcode";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_termsPage loadRequest:urlRequest];
    
    // Disable the registration button until the user agrees to the terms and conditions
    [_registerButton setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returnToLogin:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// Return from terms and conditions view to registration view
-(IBAction)returnFromTerms:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

// Updates the view when the user turns the agree swith on or off
-(IBAction)agreeToTerms:(id)sender {
    if([_agreeSwitch isOn]) {
        [UIView performWithoutAnimation:^{
            [_registerButton setEnabled:YES];
            [_registerButton layoutIfNeeded];
        }];
    }
    else {
        [UIView performWithoutAnimation:^{
            [_registerButton setEnabled:NO];
            [_registerButton layoutIfNeeded];
        }];
    }
}

// Register user and navigate to newest observations
-(IBAction)registerUser:(id)sender {
    // Make Sure passwords match
    if(![_passwordField.text isEqualToString:_confirmPassword.text]) {
        [_errorMessage setText:@"The passwords you have entered do not match. Please try again"];
        [_errorMessage setHidden:FALSE];
        return;
    }
    
    // Hide the error message if it was there from a previous attempt
    [_errorMessage setHidden:TRUE];
    
    // Register the user
    NSMutableDictionary *userData = [NSMutableDictionary new];
    [userData setObject:_userNameField.text forKey:@"name"];
    [userData setObject:_emailAddressField.text forKey:@"mail"];
    [userData setObject:_passwordField.text forKey:@"pass"];
    [userData setValue:@"Accept" forKey:@"legal_accept"];
    [DIOSUser userRegister:userData
                   success:^(AFHTTPRequestOperation *op, id response) {
                       // If the user was successfully registered display a pop up with intructions on what to do next
                       // When the user dismisses the pop up they will be navigated to the login view
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful"
                                                                       message:@"Before you can log in, you must validate your account. You will have received an email to activate your account."
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                       [alert show];
                   }
                   failure:^(AFHTTPRequestOperation *op, NSError *err) {
                       // Display an error message to the user
                       [_errorMessage setText:@"Could not create account at this time. Please try again later"];
                       [_errorMessage setHidden:FALSE];
                   }
     ];
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //Ok clicked
        // Return to newest view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *userAccountViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        // create UINavigationController to house it
        UINavigationController *destinationViewController = [[UINavigationController alloc] initWithRootViewController:userAccountViewController];
        
        // swap new view controller into the FrontViewController
        [self.revealViewController setFrontViewController:destinationViewController animated:YES];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
}

@end
