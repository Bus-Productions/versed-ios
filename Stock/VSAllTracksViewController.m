//
//  VSMainViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSAllTracksViewController.h"
#import "VSTrackTableViewCell.h"
#import "VSTrackViewController.h"
#import "VSMyTracksViewController.h"
#import "VSMessagesViewController.h"

@import QuartzCore;

#define SAVE_TO_MY_TRACKS_TEXT @"Save to my tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove from my tracks"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSAllTracksViewController ()

@end

@implementation VSAllTracksViewController

@synthesize categoriesWithTracks, tableView;
@synthesize horizontalMenu;
@synthesize menuButtons;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupData];
    
    selectedIndex = -1;
    
    [self setupSidebar];
    [self setupMenu];
    [self setupNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScreen];
}

# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"All Tracks"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController setDelegate:self];
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"updatedMyTracks" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showDiscussion" object:nil];
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void) setupData
{
    self.categoriesWithTracks = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy] : [[NSMutableArray alloc] init];
}

- (void) setupMenu
{
    if ((!self.menuButtons || [self.menuButtons count] == 0) && self.categoriesWithTracks && [self.categoriesWithTracks count] > 0) {
        
        [self.horizontalMenu setFrame:CGRectMake(self.horizontalMenu.frame.origin.x, self.horizontalMenu.frame.origin.y, self.view.frame.size.width, self.horizontalMenu.frame.size.height)];
        
        self.menuButtons = [[NSMutableArray alloc] init];
        UIFont* font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
        CGFloat topMarginSpacing = 10.0f;
        CGFloat spacing = 10.0f;
        CGFloat aggregateWidth = 0.0f;
        NSInteger i = 0;
        
        for (NSDictionary* category in self.categoriesWithTracks) {
            NSString* categoryName = [[[category objectForKey:@"category"] categoryName] lowercaseString];
            
            CGSize textSize = [categoryName sizeWithAttributes:@{NSFontAttributeName:font}];
            CGFloat strikeWidth = textSize.width;
            
            UIButton* newButton = [[UIButton alloc] initWithFrame:CGRectMake(spacing*(i+1)+aggregateWidth, topMarginSpacing, strikeWidth+20.0f, self.horizontalMenu.frame.size.height-2*topMarginSpacing)];
            [newButton setTitle:categoryName forState:UIControlStateNormal];
            [[newButton titleLabel] setTextColor:[UIColor blackColor]];
            [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[newButton titleLabel] setFont:font];
            [newButton setTag:i];
            [newButton setBackgroundColor:[UIColor clearColor]];
            newButton.layer.cornerRadius = 4;
            newButton.clipsToBounds = YES;
            [newButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            aggregateWidth = aggregateWidth+newButton.frame.size.width;
            
            [self.menuButtons addObject:newButton];
            
            [self.horizontalMenu addSubview:newButton];
            
            ++i;
        }
        
        [self.horizontalMenu setContentSize:CGSizeMake(spacing*(i+1)+aggregateWidth, self.horizontalMenu.frame.size.height)];
        
        if (selectedIndex < 0 && [self.categoriesWithTracks count] > 0) {
            [self selectCategory:0];
        }
    }
}

- (void) buttonTapped:(UIButton*)sender
{
    [self selectCategory:sender.tag];
}

- (void) selectCategory:(NSInteger)tagIndex
{
    for (UIButton* button in self.menuButtons) {
        if (button.tag == tagIndex) {
            [button setSelected:YES];
            [button setBackgroundColor:[UIColor colorWithRed:0.925f green:0.925f blue:0.925f alpha:1.0f]];
        } else {
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    if ([self.categoriesWithTracks count] > tagIndex) {
        selectedIndex = tagIndex;
    }
    
    [self.tableView reloadData];
    if ([self.tableView numberOfSections] > 0 && [self.tableView numberOfRowsInSection:0] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    selectedIndex == 0 ? @"All Tracks" : [self.navigationController.navigationBar.topItem setTitle:[[[self.categoriesWithTracks objectAtIndex:selectedIndex] objectForKey:@"category"] categoryName]];
}


# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/categories.json" withMethod:@"GET" withParamaters:nil authType:@"none"
                           success:^(id responseObject){
                               self.categoriesWithTracks = [[[responseObject cleanDictionary] objectForKey:@"categories"] mutableCopy];
                               [self.categoriesWithTracks saveLocalWithKey:@"categories"
                                            success:^(id responseObject) {
                                                [self.tableView reloadData];
                                                [self setupMenu];
                                            } failure:^(NSError* error) {
                                                
                                            }
                                ];
                           } failure:^(NSError* error) {
                           }
     ];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (selectedIndex >= 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self.categoriesWithTracks objectAtIndex:selectedIndex] objectForKey:@"category"] objectForKey:@"tracks"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[[[[self.categoriesWithTracks objectAtIndex:selectedIndex] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row] mutableCopy];
    VSTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    //[cell.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell configureWithTrack:track andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[[[[self.categoriesWithTracks objectAtIndex:selectedIndex] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row] mutableCopy];
    return 165.0f + [self heightForText:[track objectForKey:@"description"] width:(self.view.frame.size.width-40.0f) font:[UIFont fontWithName:@"SourceSansPro-Regular" size:15.0f]];
    //return 276.0f;
}

- (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font
{
    if (!text || [text length] == 0) {
        return 0.0f;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 100000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    //if (self.categoriesWithTracks.count > 0) {
    //    return [[[self.categoriesWithTracks objectAtIndex:section] objectForKey:@"category"] objectForKey:@"category_name"];
    //}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
    [vc setTrack:[[[[self.categoriesWithTracks objectAtIndex:selectedIndex] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}



- (void) handleNotification:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"showDiscussion"]) {
        [self handleShowDiscussionResponse:[notification userInfo]];
    } else if ([[notification name] isEqualToString:@"updatedMyTracks"]){
        [self handleMyTracksResponse:[notification userInfo]];
    }
}

- (void) handleMyTracksResponse:(NSDictionary*)notification
{
    NSMutableArray *myTracks = [[[notification objectForKey:@"my_tracks"] mutableCopy] cleanArray];
    if (NULL_TO_NIL(myTracks)) {
        [myTracks saveLocalWithKey:@"myTracks" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    } else {
        [[[NSMutableArray alloc] init] destroyLocalWithKey:@"myTracks" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }
}

- (void) handleShowDiscussionResponse:(NSDictionary*)notification
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSMessagesViewController *vc = (VSMessagesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"messagesViewController"];
    [vc setTrack:[[notification objectForKey:@"track"] mutableCopy]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
