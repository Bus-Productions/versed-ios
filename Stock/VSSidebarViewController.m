//
//  VSSidebarViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSidebarViewController.h"
#import "VSTracksViewController.h"
#import "SWRevealViewController.h"

@interface VSSidebarViewController ()

@end

@implementation VSSidebarViewController

@synthesize tableView, menuOptions, menuIdentifiers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuOptions = [[NSMutableArray alloc] initWithObjects:@"Quiz", @"My Tracks", nil];
    self.menuIdentifiers = [[NSMutableArray alloc] initWithObjects:@"quizCell", @"myTracksCell", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.menuOptions.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    NSString *textToSet;
    if (indexPath.row == 0) {
        identifier = @"titleCell";
        textToSet = @"Versed";
    } else {
        identifier = [self.menuIdentifiers objectAtIndex:indexPath.row - 1];
        textToSet = [self.menuOptions objectAtIndex:indexPath.row - 1];
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:1];
    [lbl setText:textToSet];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealViewController = self.revealViewController;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSTracksViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"tracksViewController"];\
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"mainViewNavigationController"];
    [nc setViewControllers:@[vc] animated:NO];
    
    [revealViewController setFrontViewController:nc];
    [revealViewController revealToggleAnimated:YES];
}


@end
