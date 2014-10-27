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
#define BUS_ERROR @"An unexpected error has occurred. Please contact GBIS Simon through Service Now for assistance if this issue persists."
#define CRU_ERROR @"An unexpected error has occurred. Please contact the CRU for assistance if this issue persists."

#define XPIRE_MSG @">Please enter your userid and password.<"

#define BROKER_GROUP @"License_Producer"

@property NSURLSessionConfiguration *sessionConfig;
@property NSURLSession *session;
@property BOOL isLogin;
@property BOOL isRefresh;
@property NSString *env;
@property NSString *domain;
@property NSString *pkmsloginForm;
@property NSString *junctionAndSimon;
@property NSString *searchAction;
@property NSString *caseAction;
@property NSString *staticDataAction;

@property NSMutableArray *RGOs;
@property NSMutableDictionary *salesReps;

- (BOOL) defaultSessionConfiguration;
- (BOOL) delegateFreeSession;
- (void) invalidateWebseal;
- (MD1SimonResponse *) login:(NSString *) userid password:(NSString *) password;
- (MD1SimonResponse *) search:(NSString *)json;
- (MD1SimonResponse *) getCase:(NSString *)json;
- (MD1SimonResponse *) getStaticData;
+ (BOOL) isBroker:(NSString *) group;
+ (NSString *) getUserError:(NSString *) group;

@end
