//
//  VSMessageTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/8/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSMessageTableViewCell : UITableViewCell

-(void) configureWithMessage:(NSMutableDictionary*)message; 

@end
