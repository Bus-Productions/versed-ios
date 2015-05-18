//
//  VSTrackViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackViewController.h"
#import "VSResourceTableViewCell.h"

@interface VSTrackViewController ()

@end

@implementation VSTrackViewController

@synthesize track, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScreen];
}

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[self.track headline]];
}

- (void) setupData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[track keyForTrack]]) {
        self.track = [[[NSUserDefaults standardUserDefaults] objectForKey:[self.track keyForTrack]] mutableCopy];
    }
}

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/tracks/%@/resources_for_user", [self.track ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.track = [[responseObject objectForKey:@"track"] mutableCopy];
        [self.track setObject:[responseObject resources] forKey:@"resources"];
        [[self.track cleanDictionary] saveLocalWithKey:[self.track keyForTrack]
                             success:^(id responseObject) {
                                 [self.tableView reloadData];
                             }
                             failure:nil];
    }failure:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.track resources] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *resource = [self resourceAtIndexPath:indexPath];
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:resource];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSResourceViewController *vc = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
    [vc setResource:[self resourceAtIndexPath:indexPath]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helpers

- (NSMutableDictionary*) resourceAtIndexPath:(NSIndexPath*)indexPath
{
    return [[[self.track resources] objectAtIndex:indexPath.row] mutableCopy];
}

@end
