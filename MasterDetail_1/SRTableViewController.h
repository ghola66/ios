//
//  CustomTableViewController.h
//  CustomTable
//
//  Created by Simon on 7/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesRep.h"

@interface SRTableViewController : UITableViewController

@property (nonatomic, weak) NSDictionary *SalesReps;
@property (nonatomic, weak) SalesRep *SRselected;

@end
