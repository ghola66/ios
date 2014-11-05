//
//  MD1PlanViewController.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/5/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MD1PlanViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property NSDictionary *CaseSearchDataJSon;
@property NSMutableDictionary *planData;
@property NSMutableArray *processesData;
@property (weak, nonatomic) NSString *userGroup;

- (void) segueData:(NSDictionary *)jCSD;

@end
