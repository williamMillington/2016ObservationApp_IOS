//
//  SearchPanelView.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-10.
//  Copyright © 2016 William Millington. All rights reserved.
//

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
    
    // Grab searchbar text
    SearchViewController *parent = (SearchViewController *)[[[self superview] superview] nextResponder];
    UISearchBar *searchbar = (UISearchBar *)parent.navigationItem.titleView;
    NSString *searchString = [searchbar text];
    
    // set string as parameter
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:searchString forKey:@"title"];
    
    // fetch observations
    [parent fetchObservations:parameters];
}
@end







