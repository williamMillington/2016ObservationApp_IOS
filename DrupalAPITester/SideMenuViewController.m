//
//  SideMenuViewController.m
//  ObservationApp
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
#import "SideMenuViewController.h"

#import "UserLoginNavigationViewController.h"

@interface SideMenuViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewControllerCache;
//@property (nonatomic, strong) UIViewController *current;
@end

@implementation SideMenuViewController{
    NSArray  *menuItems;
}

@synthesize viewControllerCache;



- (instancetype) initWithCoder:(NSCoder *)aDecoder  {
    
    // create the viewControllerCache
    self.viewControllerCache = [[NSMutableDictionary alloc] init];
    
    // create cacheKey for initial NavigationViewController
    NSString *cacheKey = @"NewestViewController";
    // create newest observations view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ObservationCollectionViewController *newestViewController =
    [storyboard instantiateViewControllerWithIdentifier:cacheKey];
    
    // create UINavigationController to contain newestViewController
//    UINavigationController *startViewController =
//    [[UINavigationController alloc]  initWithRootViewController:newestViewController];
    
    UserLoginNavigationViewController *startViewController = [[UserLoginNavigationViewController alloc]  initWithRootViewController:newestViewController];
    
    
    // set it into the cache
    [self.viewControllerCache setObject:startViewController forKey:cacheKey];
    self.current = startViewController;
    
    return [super initWithCoder:aDecoder];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = @[@"title", @"newest", @"search"];
    
    // eliminates warning about ambiguous cell height
    self.tableView.rowHeight = 45;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch(indexPath.row)
    {
        case 0:
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"uid"])
                [self showViewControllerForSegueWithIdentifier:@"UserViewController" sender:nil];
            else
                [self showViewControllerForSegueWithIdentifier:@"LoginViewController" sender:nil];
            break;
        case 1:
            [self showViewControllerForSegueWithIdentifier:@"NewestViewController" sender:nil];
            break;
        case 2:
            [self showViewControllerForSegueWithIdentifier:@"SearchViewController" sender:nil];
            break;
        default:
            break;
    }
    
}


- (void)showViewControllerForSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // search the cache for a UINavigationController with
    // the requested key
    NSString *cacheKey = identifier;
    
    UserLoginNavigationViewController *destinationViewController = [self.viewControllerCache objectForKey:cacheKey];
//    UINavigationController *destinationViewController =
//                                    [self.viewControllerCache objectForKey:cacheKey];
    
    // if controller exists, swap it into the FrontViewController
    if(destinationViewController)
    {
        [self.revealViewController setFrontViewController:destinationViewController animated:NO];
        self.current = destinationViewController;
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
    else // create it
    {
        
        // use 'identifier' to create specific ViewController required
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *searchViewCont =
                                [storyboard instantiateViewControllerWithIdentifier:identifier];
        // create UINavigationController to house it
        destinationViewController =
                    [[UserLoginNavigationViewController alloc] initWithRootViewController:searchViewCont];
        
        
        // stick it in the cache
        [self.viewControllerCache setObject:destinationViewController forKey:cacheKey];
        
        
        // swap new view controller into the FrontViewController
        [self.revealViewController setFrontViewController:destinationViewController animated:NO];
        self.current = destinationViewController;
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
}






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
