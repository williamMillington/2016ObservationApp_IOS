//
//  SearchPanelView.m
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

#import "SearchPanelView.h"

@implementation SearchPanelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)executeSearch:(id)sender {
    
    SearchViewController *parent = (SearchViewController *)[[[self superview] superview] nextResponder];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    UISearchBar *searchbar = (UISearchBar *)parent.navigationItem.titleView;
    NSString *searchString = [searchbar text];
    
    
//    NSLog(@"REACHED 1");
    [parameters setObject:searchString forKey:@"title"];
//    parameters 
//    NSLog(@"%@",searchString);
    
    [parent fetchObservations:parameters];
//    NSLog(@"REACHED 2");
}
@end







