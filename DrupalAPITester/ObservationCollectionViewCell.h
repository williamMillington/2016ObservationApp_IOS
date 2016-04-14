//
//  ObservationCollectionViewCell.h
//  DrupalAPITester
//
/**	 ObservationApp, Copyright 2016, University of Prince Edward Island,
 *    550 University Avenue, C1A4P3,
 *    Charlottetown, PE, Canada
 *
 * 	 @author William Millington<wmillington@upei.ca>
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

#import <UIKit/UIKit.h>

@interface ObservationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *observation_title;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) NSString *nid;
@property (weak, nonatomic) NSString *uid;
@property (weak, nonatomic) NSString *field_date_observed;

@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;

@end
