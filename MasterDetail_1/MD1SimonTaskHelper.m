//
//  MD1SimonTaskHelper.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MBProgressHUD.h"
#import "MD1AppDelegate.h"
#import "MD1SimonTaskHelper.h"

@implementation MD1SimonTaskHelper

- (void) start:(NSURLSession *) session request:(NSMutableURLRequest *) request data:(NSData *) data
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.session = session;
    self.request = request;
    self.data = data;
    self.task = [session uploadTaskWithRequest:request fromData:data
    
                             completionHandler:^(NSData *data, NSURLResponse *response,
                                                 NSError *error) {
                                 self.response = response;
                                 self.httpResponse = (NSHTTPURLResponse *) response;
                                 self.error = error;
                                 self.responseData = data;
                                 self.responseString = [[NSString alloc] initWithData: data
                                                                             encoding: NSUTF8StringEncoding];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 NSLog(@"MD1SimonTaskHelper.start, response:%@,  error:%@", self.httpResponse, error);
                                 NSLog(@"DATA:\n%@\nEND DATA\n", self.responseString);
                                 });
                             }];
    
    [self.task resume];
}

- (void) startSync:(NSURLSession *) session request:(NSMutableURLRequest *) request data:(NSData *) data wait:(int)wait
{
    MD1AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIView *topView = appDelegate.window.rootViewController.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topView animated:YES];
    hud.labelText = @"Network Activity";
    
    [self start:session request:request data:data];
    int count = 0;
    while((self.task.state != NSURLSessionTaskStateCompleted || !self.httpResponse) && !self.error && count < wait) {
        NSDate *future = [NSDate dateWithTimeIntervalSinceNow:1];
        //[NSThread sleepUntilDate:future];
        [[NSRunLoop currentRunLoop] runUntilDate:future];
        count++;
    }
    if(count == wait) {
        [self.task cancel];
    }
    [MBProgressHUD hideHUDForView:topView animated:YES];
}
@end