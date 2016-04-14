//
//  DrupalAPITesterTests.m
//  DrupalAPITesterTests
//
/**	 ObservationApp, Copyright 2016, University of Prince Edward Island,
 *    550 University Avenue, C1A4P3,
 *    Charlottetown, PE, Canada
 *
 * 	 @author Jonathan Cudmore<jrcudmore@upei.ca>
 *
 *   This file is part of ObservationApp.
 *
 *   ObservationApp is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Observation App.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import "UserRegisterViewController.h"
#import "UserViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"


@interface DrupalAPITesterTests : XCTestCase {

@private
    UIApplication               *app;
    AppDelegate                 *appDelegate;
    LoginViewController         *loginViewController;
    UserRegisterViewController  *userRegisterViewController;
    UserViewController          *userViewController;
    EditProfileViewController   *editProfileViewController;
    UIView                      *loginView;
}

@end


@implementation DrupalAPITesterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self->loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self->loginViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    app = [UIApplication sharedApplication];
    loginView = loginViewController.view;
    loginViewController.username_field.text = @"cdotUser";
    loginViewController.password_field.text = @"temp1234";
    [loginViewController login_button:[loginView viewWithTag:0]];
    XCTAssert([[NSUserDefaults standardUserDefaults] valueForKey:@"token"] != nil);
}

- (void)testRegister {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self->userRegisterViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self->userRegisterViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    app = [UIApplication sharedApplication];
    
}

-(void)testEditProfile {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self->userViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    [self->userViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    app = [UIApplication sharedApplication];
}

-(void)testViewProfile {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self->editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [self->editProfileViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    app = [UIApplication sharedApplication];
}


- (void)testPerformanceExample {
    [self measureBlock:^{
        app = [UIApplication sharedApplication];
        loginView = loginViewController.view;
        loginViewController.username_field.text = @"cdotUser";
        loginViewController.password_field.text = @"temp1234";
        [loginViewController login_button:[loginView viewWithTag:0]];
        XCTAssert([[NSUserDefaults standardUserDefaults] valueForKey:@"token"] != nil);

    }];
}

@end
