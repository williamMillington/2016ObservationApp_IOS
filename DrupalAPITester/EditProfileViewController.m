//
//  EditProfileViewController.m
//  DrupalAPITester
//
//  Created by Jonathan Cudmore on 2016-04-05.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "EditProfileViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)saveButton:(id)sender {
   
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
