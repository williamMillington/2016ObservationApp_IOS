//
//  SideMenuViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"

#import "SearchViewController.h"

@interface SideMenuViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewControllerCache;
@end

@implementation SideMenuViewController{
    NSArray  *menuItems;
}

@synthesize viewControllerCache;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = @[@"title", @"newest", @"search"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // your logic will vary here, this is just an example
    
    switch(indexPath.row)
    {
        case 0:
//            NSLog(@"ROW 0 SELECTED");
            [self showViewControllerForSegueWithIdentifier:@"UserViewController" sender:nil];
            break;
        case 1:
//            NSLog(@"ROW 1 SELECTED");
            [self showViewControllerForSegueWithIdentifier:@"NewestViewController" sender:nil];
            break;
        case 2:
//            NSLog(@"ROW 2 SELECTED");
            [self showViewControllerForSegueWithIdentifier:@"SearchViewController" sender:nil];
            break;
        default:
            break;
    }
    
}

- (void)showViewControllerForSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
//    NSString *cacheKey = [identifier stringByAppendingFormat:@":%@", sender];
    NSString *cacheKey = identifier;
    UINavigationController *destViewCont = [self.viewControllerCache objectForKey:cacheKey];
    
    
//    NSLog(@"identifier: %@", identifier);
//    NSLog(@"sender: %@", sender);
//    NSLog(@"View Controller Cache: %@", self.viewControllerCache);
    
    
    
    if(destViewCont)
    {
//        NSLog(@"reusing view controller from cache");
//        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//        [navController setViewControllers: @[dvc] animated: NO ];
        
        
        [self.revealViewController setFrontViewController:destViewCont animated:NO];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
    else
    {
//        NSLog(@"creating view controller from segue");
        
        if(!self.viewControllerCache){
//            NSLog(@"init viewControllerCache");
            self.viewControllerCache = [[NSMutableDictionary alloc] init];
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *searchViewCont = [storyboard instantiateViewControllerWithIdentifier:identifier];
        
        UINavigationController *newNavContr = [[UINavigationController alloc]
                                                        initWithRootViewController:searchViewCont];
        
        
        
        [self.viewControllerCache setObject:newNavContr forKey:cacheKey];
        
//        NSLog(@"Inside View Controller Cache: %@", self.viewControllerCache);
        
        [self.revealViewController setFrontViewController:newNavContr animated:NO];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
        
//        [self performSegueWithIdentifier:identifier sender:sender];
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
