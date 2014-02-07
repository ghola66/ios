//
//  MD1PlanViewController.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/5/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MD1PlanViewController : UITableViewController

@property NSDictionary *CaseSearchDataJSon;
@property NSMutableDictionary *planData;
@property NSMutableArray *processesData;

- (void) segueData:(NSDictionary *)jCSD;

@end
