//
//  VSPromptOptions.m
//  Versed
//
//  Created by Will Schreiber on 7/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPromptOptions.h"

@interface VSPromptOptions ()

@end

@implementation VSPromptOptions

@synthesize topButton;
@synthesize bottomButton;


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupViews];
    
    [self.topButton setTitle:@"Get Versed" forState:UIControlStateNormal];
    [self.bottomButton setTitle:@"Take Quiz" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setupViews
{
    [[self.topButton layer] setBorderWidth:1.0f];
    [[self.topButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.topButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:22.0f]];
    [[self.topButton titleLabel] setTextColor:[UIColor whiteColor]];
    [self.topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[self.bottomButton layer] setBorderWidth:1.0f];
    [[self.bottomButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.bottomButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:22.0f]];
    [[self.bottomButton titleLabel] setTextColor:[UIColor whiteColor]];
    [self.bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)topAction:(id)sender
{
    [self closeWindow:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToOption" object:nil userInfo:@{@"to":@"allTracks"}];
}


- (IBAction)bottomAction:(id)sender
{
    [self closeWindow:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToOption" object:nil userInfo:@{@"to":@"quiz"}];
}

- (void) closeWindow:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated completion:^(void){
        
    }];
}

@end
