//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGO.h"

@interface RGOTableViewController : UITableViewController

@property (nonatomic, weak) NSArray *RGOs;
@property (nonatomic, weak) RGO *RGOselected;

@end
