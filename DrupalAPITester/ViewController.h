//
//  ViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-02-28.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <drupal-ios-sdk/DIOSSession.h>
#import <drupal-ios-sdk/DIOSNode.h>
#import <drupal-ios-sdk/DIOSUser.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username_field;

@property (weak, nonatomic) IBOutlet UITextField *password_field;

@property (weak, nonatomic) IBOutlet UITextView *response_textview;



- (IBAction)login_button:(id)sender forEvent:(UIEvent *)event;
- (IBAction)logout_button:(id)sender forEvent:(UIEvent *)event;

@end

