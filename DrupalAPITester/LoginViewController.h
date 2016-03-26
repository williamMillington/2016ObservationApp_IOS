//
//  LoginViewController.h
//  
//
//  Created by William Millington on 2016-03-05.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DIOSUser.h"
#import "SWRevealViewController.h"

@interface LoginViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIView *credentialsBox;
@property (weak, nonatomic) IBOutlet UITextField *username_field;
@property (weak, nonatomic) IBOutlet UITextField *password_field;
@property (weak, nonatomic) IBOutlet UILabel *wrong_credentials;



- (IBAction)remember_me:(id)sender forEvent:(UIEvent *)event;
- (IBAction)login_button:(id)sender;

- (IBAction)register_button:(id)sender;


@end
