//
//  MD1LoginViewController.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MD1LoginViewController : UIViewController <UITextFieldDelegate>

+ (void)keyChainSaveKey:(NSString *)key data:(id)data;
+ (id)keyChainLoadKey:(NSString *)key;
+ (void)keyChainDeleteKey:(NSString *)service;

@property (strong, nonatomic) NSArray *resultset;

@end
