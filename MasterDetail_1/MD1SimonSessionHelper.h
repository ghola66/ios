//
//  MD1SimonSessionHelper.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD1SimonResponse.h"

@interface MD1SimonSessionHelper : NSObject

#define LOGIN_TIMEOUT 60
#define SEARCH_TIMEOUT 60
#define BUS_ERROR @"An unexpected error has occurred. Please contact the BUS for assistance if this issue persists."

@property NSURLSessionConfiguration *sessionConfig;
@property NSURLSession *session;
@property BOOL isLogin;
@property NSString *env;
@property NSString *domain;
@property NSString *pkmsloginForm;
@property NSString *junctionAndSimon;
@property NSString *searchAction;

- (BOOL) defaultSessionConfiguration;
- (BOOL) delegateFreeSession;
- (MD1SimonResponse *) login:(NSString *) userid password:(NSString *) password;
- (MD1SimonResponse *) search:(NSString *)json;

@end