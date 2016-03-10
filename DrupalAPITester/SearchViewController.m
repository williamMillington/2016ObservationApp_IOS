//
//  SearchViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "SearchPanelView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController{
//    UIView *searchPanel;
//    UIVisualEffectView *searchPanel;
    SearchPanelView *searchPanel;
    Boolean searchPanelVisible;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style: UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    
    // Define search bar and add it to menu
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchbar;
    
    
    // Define search panel toggle button and add it to menu
    UIBarButtonItem *searchToggleButton = [[UIBarButtonItem alloc] initWithTitle:@"expand" style: UIBarButtonItemStylePlain target:self action:@selector(toggleSearchPanel)];
    self.navigationItem.rightBarButtonItem = searchToggleButton;
    
    
    // Define search panel and add it to view
    // (-300) the search panel is created off-screen
    int panelHeight = 350;
//    searchPanel = [[UIView alloc] initWithFrame:CGRectMake(0, -panelHeight, 320, panelHeight)];
    searchPanel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:searchPanel];
    
    
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
        
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        searchPanel = [[SearchPanelView alloc] initWithEffect:blurEffect];
        searchPanel.frame = CGRectMake(0, -panelHeight, 320, panelHeight);
        searchPanel.backgroundColor = [UIColor clearColor];
//
        searchPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    searchPanel = []
    
    [self.view addSubview:searchPanel];
//    }
//    else {
//        self.view.backgroundColor = [UIColor blackColor];
//    }
    
    
    
    
    // Panel Controls
//    UILabel *groupByLabel = [UILabel alloc] initWithFr
    
    
    
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Method responsible for toggling the reveal/hide
// of the search panel
- (void)toggleSearchPanel {
    
    
    if(!searchPanelVisible){
        
        // Set the top of the search panel to perfectly
        // align with th bottom of the navbar
        CGRect navbarFrame = self.navigationController.navigationBar.frame;
        CGRect newSearchPanelFrame = searchPanel.frame;
        newSearchPanelFrame.origin.y = (navbarFrame.origin.y + navbarFrame.size.height);
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Assign new coordinates to search panel
        searchPanel.frame = newSearchPanelFrame;
        searchPanelVisible = TRUE;
        
        // Begin animation
        [UIView commitAnimations];
        
    }
    else {
        
        // Set search panel to disappear into the top of the
        // screen the entirety of its height
        CGRect newSearchPanelFrame = searchPanel.frame;
        newSearchPanelFrame.origin.y = -newSearchPanelFrame.size.height;
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Set new coordinates of search panel
        searchPanel.frame = newSearchPanelFrame;
        searchPanelVisible = FALSE;
        
        // Begin animation
        [UIView commitAnimations];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
