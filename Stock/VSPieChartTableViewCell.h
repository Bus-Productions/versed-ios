//
//  VSPieChartTableViewCell.h
//  Versed
//
//  Created by Joseph Gill on 7/30/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSPieChartTableViewCell : UITableViewCell

- (void) configureWithPoll:(NSMutableDictionary*)poll andColors:(NSArray *)colors;

@end
