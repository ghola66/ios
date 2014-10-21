//
//  CustomTableViewController.h
//  CustomTable
//
//  Created by Simon on 7/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGO.h"

@interface RGOTableViewController : UITableViewController

@property (nonatomic, weak) NSArray *RGOs;
@property (nonatomic, weak) RGO *RGOselected;

@end
