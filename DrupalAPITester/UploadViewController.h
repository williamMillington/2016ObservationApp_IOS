//
//  UploadViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image_to_upload;

- (IBAction)cancel:(id)sender;

@end
