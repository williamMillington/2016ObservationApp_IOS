//
//  ObservationCollectionViewCell.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-01.
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

@interface ObservationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *observation_title;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) NSString *nid;
@property (weak, nonatomic) NSString *uid;
@property (weak, nonatomic) NSString *field_date_observed;

@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;

@end
