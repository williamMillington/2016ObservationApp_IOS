//
//  EditProfileViewController.m
//  DrupalAPITester
//
//  Created by Jonathan Cudmore on 2016-04-05.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "EditProfileViewController.h"
#import "DIOSUser.h"
#import "DIOSSession.h"

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *l1AddressLine1;
@property (weak, nonatomic) IBOutlet UITextField *l1AddressLine2;
@property (weak, nonatomic) IBOutlet UITextField *l1City;
@property (weak, nonatomic) IBOutlet UITextField *l1Province;
@property (weak, nonatomic) IBOutlet UITextField *l1PostalCode;
@property (weak, nonatomic) IBOutlet UITextField *l1Country;
@property (weak, nonatomic) IBOutlet UITextField *l2AddressLine1;
@property (weak, nonatomic) IBOutlet UITextField *l2AddressLine2;
@property (weak, nonatomic) IBOutlet UITextField *l2City;
@property (weak, nonatomic) IBOutlet UITextField *l2Province;
@property (weak, nonatomic) IBOutlet UITextField *l2PostalCode;
@property (weak, nonatomic) IBOutlet UITextField *l2Country;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add current user values to the fields for editing
    _userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    
    _l1AddressLine1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1AddressLine1"];
    _l1AddressLine2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1AddressLine2"];
    _l1City.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1City"];
    _l1Province.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1Province"];
    _l1PostalCode.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1PostalCode"];
    _l1Country.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l1Country"];
    
    _l2AddressLine1.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2AddressLine1"];
    _l2AddressLine2.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2AddressLine1"];
    _l2City.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2City"];
    _l2Province.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2Province"];
    _l2PostalCode.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2PostalCode"];
    _l2Country.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"l2Country"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)saveButton:(id)sender {
    
    // Set csrfToken
    [DIOSSession sharedSession].csrfToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    // Update user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:_userName.text forKey:@"userName"];
    
    // Save address 1 if changed
    if(![_l1AddressLine1.text isEqualToString:[defaults valueForKey:@"l1AddressLine1"]])
        [defaults setValue:_l1AddressLine1.text forKey:@"l1AddressLine1"];
    if(![_l1AddressLine2.text isEqualToString:[defaults valueForKey:@"l1AddressLine2"]])
        [defaults setValue:_l1AddressLine2.text forKey:@"l1AddressLine2"];
    if(![_l1City.text isEqualToString:[defaults valueForKey:@"l1City"]])
        [defaults setValue:_l1City.text forKey:@"l1City"];
    if(![_l1Province.text isEqualToString:[defaults valueForKey:@"l1Province"]])
        [defaults setValue:_l1Province.text forKey:@"l1Province"];
    if(![_l1PostalCode.text isEqualToString:[defaults valueForKey:@"l1PostalCode"]])
        [defaults setValue:_l1PostalCode.text forKey:@"l1PostalCode"];
    
    // Save address l2 if changed
    if(![_l2AddressLine1.text isEqualToString:[defaults valueForKey:@"l2AddressLine1"]])
        [defaults setValue:_l2AddressLine1.text forKey:@"l2AddressLine1"];
    if(![_l2AddressLine2.text isEqualToString:[defaults valueForKey:@"l2AddressLine2"]])
        [defaults setValue:_l2AddressLine2.text forKey:@"l2AddressLine2"];
    if(![_l2City.text isEqualToString:[defaults valueForKey:@"l2City"]])
        [defaults setValue:_l2City.text forKey:@"l2City"];
    if(![_l2Province.text isEqualToString:[defaults valueForKey:@"l2Province"]])
        [defaults setValue:_l2Province.text forKey:@"l2Province"];
    if(![_l2PostalCode.text isEqualToString:[defaults valueForKey:@"l2PostalCode"]])
        [defaults setValue:_l2PostalCode.text forKey:@"l2PostalCode"];
    
    // Create dictionaries for the locations so it can be read into the drupal addressfield
    NSDictionary *location1 = @{@"und":@[@{@"administrative_area":_l1Province.text, @"country":_l1Country.text, @"data":@"", @"dependent_locality":@"", @"first_name":@"", @"last_name":@"", @"locality":_l1City.text, @"name_line":@"", @"organisation_name":@"", @"postal_code":_l1PostalCode.text, @"premise":_l1AddressLine2.text, @"sub_administrative_area":@"", @"sub_premise":@"", @"thoroughfare":_l1AddressLine1.text}]};
    
    NSDictionary *location2 = @{@"und":@[@{@"administrative_area":_l2Province.text, @"country":_l2Country.text, @"data":@"", @"dependent_locality":@"", @"first_name":@"", @"last_name":@"", @"locality":_l2City.text, @"name_line":@"", @"organisation_name":@"", @"postal_code":_l2PostalCode.text, @"premise":_l2AddressLine2.text, @"sub_administrative_area":@"", @"sub_premise":@"", @"thoroughfare":_l2AddressLine1.text}]};
    
    // Update the data on the server
    NSMutableDictionary *userData = [NSMutableDictionary new];
    [userData setObject:_userName.text forKey:@"name"];
    [userData setObject:location1 forKey:@"field_l1_address"];
    [userData setObject:location2 forKey:@"field_l2_address"];
    [userData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"] forKey:@"uid"];
    [DIOSUser userUpdate:userData
                 success:^(AFHTTPRequestOperation *op, id response) {
                     NSLog(@"Success");
                     
                     // Navigate back to the profile view by dismissing this view
                     [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                 }
                 failure:^(AFHTTPRequestOperation *op, NSError *err) {
                     NSLog(@"Unable to update information");
                 }
     ];
    
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
