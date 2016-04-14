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

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style: UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    // Configure the menu button on the right side
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Give the profile picture rounded corners so it isn't as sharp
    _profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"imageUrl"]]]];
    _profilePicture.layer.cornerRadius = 10.0f;
    _profilePicture.clipsToBounds = YES;
    
    [self refreshUserInfo];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Refresh User info in case it has been changed
    [self refreshUserInfo];
}

-(IBAction)logoutAction:(id)sender {
    
    [DIOSSession sharedSession].csrfToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    [DIOSUser userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *op, id response) {
        NSLog(@"Successful Logout");
        
        // Flush user defaults
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        // Navigate away from user profile page
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *userAccountViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewestViewController"];
        
        // create UINavigationController to house it
        UINavigationController *destinationViewController = [[UINavigationController alloc] initWithRootViewController:userAccountViewController];
        
        // swap new view controller into the FrontViewController
        [self.revealViewController setFrontViewController:destinationViewController animated:YES];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Unable to logout");
                                     return;
                                 }
     ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUserInfo {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
