//
//  ObservationViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-16.
//  Copyright © 2016 William Millington. All rights reserved.
//
// This file is part of DrupalAPITester.
//
// DrupalAPITester is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Foobar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
// ---------------------------------------------------------------------------------
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
