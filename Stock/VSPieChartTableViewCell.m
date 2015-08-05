//
//  VSPieChartTableViewCell.m
//  Versed
//
//  Created by Joseph Gill on 7/30/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPieChartTableViewCell.h"
#define CHART_WIDTH 200.0
#define CHART_HEIGHT 200.0

@implementation VSPieChartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPoll:(NSMutableDictionary*)poll andColors:(NSArray *)colors
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0; i < [[poll pollAnswers] count]; i++) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:[[[poll pollAnswers] objectAtIndex:i] percentageAsFloat] color:[colors objectAtIndex:i]]];
    }
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - CHART_WIDTH/2.0, self.bounds.size.height/2 - CHART_HEIGHT/2.0, CHART_WIDTH, CHART_HEIGHT) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0];
    [pieChart strokeChart];
    [self addSubview:pieChart];
    
    NSMutableDictionary *currentPoll = [poll objectForKey:@"poll"];
    UILabel* numberTaken = (UILabel*)[self.contentView viewWithTag:2];
    [numberTaken setText:[NSString stringWithFormat:@"%@ %@", [currentPoll numberTaken], [[currentPoll numberTaken] isEqualToString:@"1"] ? @"total response" : @"total responses"]];
    [numberTaken setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];
}

@end
