//
//  SearchPanelView.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-10.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "SearchPanelView.h"

#import "SearchViewController.h"

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







