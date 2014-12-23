//
//  MD1SearchViewController.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MD1SearchViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *resultset;

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *userGroup;

@end
