//
//  ViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-02-28.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize username_field;
@synthesize password_field;
@synthesize response_textview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login_button:(id)sender forEvent:(UIEvent *)event {
    

    
    [response_textview setUserInteractionEnabled:TRUE];
    
    
    [DIOSUser
     userMakeSureUserIsLoggedInWithUsername:[username_field text]
     andPassword:[password_field text]
     success:^(AFHTTPRequestOperation *op, id response) {
         
         
         NSLog(@"SUCCESS CASE");
         [response_textview setText:[NSString stringWithFormat:@"%@", response]];
     }
     failure:^(AFHTTPRequestOperation *op, NSError *err) {
         
         NSLog(@"FAIL CASE");
         [response_textview setText:[NSString stringWithFormat:@"%@", err]];
     }
     ];
    
}

- (IBAction)logout_button:(id)sender forEvent:(UIEvent *)event {
    
    
    [DIOSUser
     userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *op, id response) {
         
         NSLog(@"SUCCESS CASE");
         [response_textview setText:[NSString stringWithFormat:@"%@", response]];
     }
     failure:^(AFHTTPRequestOperation *op, NSError *err) {
     
         
         NSLog(@"FAIL CASE");
         [response_textview setText:[NSString stringWithFormat:@"%@", err]];
     }
     ];
    
    
    
}
@end
