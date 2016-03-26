//
//  ObservationViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-16.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIOSNode.h"

#import <MapKit/MapKit.h>

@interface ObservationViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *observation_image;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date_observed;
@property (weak, nonatomic) IBOutlet UILabel *observation_title;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *ui_block_1;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *ui_block_2;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *observation_info_block;

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *user_image;



@property (strong, nonatomic) NSDictionary *cellData;
@property (weak, nonatomic) NSDictionary *observation;
@property (weak, nonatomic) NSDictionary *user;
@property (weak, nonatomic) CLLocation *location;

- (IBAction)openUser:(id)sender;
- (void) reload;

#define METERS_PER_MILE 1609.344

@end
