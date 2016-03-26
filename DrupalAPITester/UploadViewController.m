//
//  UploadViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController{
    UIScrollView *scrollView;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView = [[self.view subviews] objectAtIndex:0];
    int screenWidth = self.view.frame.size.width;
    int screenHeight = self.view.frame.size.height;
    scrollView.contentSize = CGSizeMake(screenWidth,screenHeight+200);
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

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
