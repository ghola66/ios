//
//  MD1ProcessViewController.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/5/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MD1ProcessViewController : UITableViewController

@property NSDictionary *processData;

- (void) segueData:(NSDictionary *)processData;

@end
