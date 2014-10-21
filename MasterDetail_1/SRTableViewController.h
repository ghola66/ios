//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesRep.h"

@interface SRTableViewController : UITableViewController

@property (nonatomic, weak) NSDictionary *SalesReps;
@property (nonatomic, weak) SalesRep *SRselected;

@end
