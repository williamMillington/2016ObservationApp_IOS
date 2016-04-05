//
//  UserRegisterViewController.m
//  DrupalAPITester
//
//  Created by Jonathan Cudmore on 2016-04-04.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "DIOSSession.h"
#import "DIOSUser.h"

@interface UserRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_registerButton setEnabled:FALSE];
    CGRect buttonFrame = _registerButton.frame;
    buttonFrame.size = CGSizeMake(280, 100);
    _registerButton.frame = buttonFrame;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Return from terms and conditions view
-(IBAction)returnFromTerms:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)agreeToTerms:(id)sender {
    if(!_registerButton.isEnabled) {
        [_registerButton setHidden:TRUE];
        sleep(1);
        CGRect buttonFrame = _registerButton.frame;
        buttonFrame.size = CGSizeMake(100, 100);
        _registerButton.frame = buttonFrame;
        [_registerButton setEnabled:YES];
        [_registerButton setHidden:FALSE];
    }
    else {
        return;
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
    
    [_errorMessage setHidden:TRUE];
    NSMutableDictionary *userData = [NSMutableDictionary new];
    [userData setObject:_userNameField.text forKey:@"name"];
    [userData setObject:_emailAddressField.text forKey:@"mail"];
    [userData setObject:_passwordField.text forKey:@"pass"];
    [DIOSUser userRegister:userData
                   success:^(AFHTTPRequestOperation *op, id response) {
                       /* Handle successful operation here */
                       [[self navigationController] popToRootViewControllerAnimated:TRUE];
                   }
                   failure:^(AFHTTPRequestOperation *op, NSError *err) {
                       /* Handle operation failire here */
                       [_errorMessage setText:@"Could not create account at this time. Please try again later"];
                       [_errorMessage setHidden:FALSE];
                   }
     ];
}

@end
