//
//  LoginViewController.h
//  
//
//  Created by William Millington on 2016-03-05.
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
#import "XMLReader.h"

@interface LoginViewController : UIViewController




@property (weak, nonatomic) IBOutlet UIView *credentialsBox;
@property (weak, nonatomic) IBOutlet UITextField *username_field;
@property (weak, nonatomic) IBOutlet UITextField *password_field;
@property (weak, nonatomic) IBOutlet UILabel *wrong_credentials;


- (IBAction)login_button:(id)sender;

@end
