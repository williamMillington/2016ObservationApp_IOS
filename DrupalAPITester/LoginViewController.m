//
//  LoginViewController.m
//  
//
//  Created by William Millington on 2016-03-05.
//
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    
    // Style the view holding the username and
    // password fields
    [credentialsBox.layer setCornerRadius:10.0f];
    [credentialsBox.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
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



- (IBAction)remember_me:(id)sender forEvent:(UIEvent *)event {}


- (IBAction)login_button:(id)sender {
    
    [DIOSUser
        userMakeSureUserIsLoggedInWithUsername:[username_field text]
        andPassword:[password_field text]
        success:^(AFHTTPRequestOperation *op, id response) {
         
         // Hide the wrong credentials if it was showing
         // from a previous attempt
         [wrong_credentials setHidden:TRUE];
         
         // Segue back to the app
         [self performSegueWithIdentifier:@"closeLoginInterface" sender:self];
         
        }
        failure:^(AFHTTPRequestOperation *op, NSError *err) {
         
         // Show label informing the user of the error
         [wrong_credentials setHidden:FALSE];
        }
     ];
    
    
    
}

- (IBAction)register_button:(id)sender {}
@end
