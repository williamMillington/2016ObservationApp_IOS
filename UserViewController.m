//
//  UserViewController.m
//  DrupalAPITester
//
//  Created by Jonathan Cudmore on 2016-03-30.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "DIOSSession.h"
#import "DIOSUser.h"

@interface UserViewController ()

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

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style: UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    
    self.navigationItem.leftBarButtonItem = sidebarButton;
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Make sure the user is logged in and display user info
    [DIOSUser userMakeSureUserIsLoggedInWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]
                                         andPassword: [[NSUserDefaults standardUserDefaults] valueForKey:@"password"]
                                             success:^(AFHTTPRequestOperation *op, id response){
                                                 
                                                 _profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"imageUrl"]]]];
                                                 _userName.text= [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
                                                 _emailAddress.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailAddress"];
                                                 
                                                 if([[NSUserDefaults standardUserDefaults] valueForKey:@"l1Country"]) {
                                                     _countryL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1Country"];
                                                     _firstAddressL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1AddressLine1"];
                                                     _secondAddressL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1secondAddressLine2"];
                                                     _provinceL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1Province"];
                                                     _postalCodeL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1PostalCode"];
                                                     _cityL1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1City"];
                                                 }
                                                 else {
                                                     [_location1 setHidden:TRUE];
                                                     [_countryL1 setHidden:TRUE];
                                                     [_firstAddressL1 setHidden:TRUE];
                                                     [_secondAddressL1 setHidden:TRUE];
                                                     [_provinceL1 setHidden:TRUE];
                                                     [_postalCodeL1 setHidden:TRUE];
                                                     [_cityL1 setHidden:TRUE];
                                                 }
                                                 
                                                 if([[NSUserDefaults standardUserDefaults] valueForKey:@"l2Country"]) {
                                                     _countryL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2Country"];
                                                     _firstAddressL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2AddressLine1"];
                                                     _secondAddressL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2AddressLine2"];
                                                     _provinceL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2Province"];
                                                     _postalCodeL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2PostalCode"];
                                                     _cityL2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2City"];
                                                 }
                                                 else {
                                                     [_location2 setHidden:TRUE];
                                                     [_countryL2 setHidden:TRUE];
                                                     [_firstAddressL2 setHidden:TRUE];
                                                     [_secondAddressL2 setHidden:TRUE];
                                                     [_provinceL2 setHidden:TRUE];
                                                     [_postalCodeL2 setHidden:TRUE];
                                                     [_cityL2 setHidden:TRUE];
                                                 }
                                             }
     
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                                 NSLog(@"FAILURE USER PROFILE");
                                             }
     ];
    
}

-(IBAction)logoutAction:(id)sender {
    
    [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *op, id response) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

        [[self navigationController] popToRootViewControllerAnimated:TRUE];
        
    }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Nope");
                                 }
     ];
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

@end
