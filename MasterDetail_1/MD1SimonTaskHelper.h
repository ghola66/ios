//
//  MD1SimonTaskHelper.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD1SimonTaskHelper : NSObject

@property NSURLSessionUploadTask *task;
@property NSURLSession *session;
@property NSMutableURLRequest *request;
@property NSData *data;
@property NSURLResponse *response;
@property NSHTTPURLResponse *httpResponse;
@property NSError *error;
@property NSString *responseString;
@property NSData *responseData;


- (void) start:(NSURLSession *) session request:(NSMutableURLRequest *) request data:(NSData *) data;
- (void) startSync:(NSURLSession *) session request:(NSMutableURLRequest *) request data:(NSData *) data wait:(int) wait msg:(NSString *) msg;
- (void) startSync:(NSURLSession *) session request:(NSMutableURLRequest *) request data:(NSData *) data wait:(int) wait view:(UIView *) view  msg:(NSString *) msg;

@end
