//
//  MD1SimonSessionHelper.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/29/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1SimonResponse.h"
#import "MD1SimonSessionHelper.h"
#import "MD1SimonTaskHelper.h"

@implementation MD1SimonSessionHelper

- (MD1SimonSessionHelper *) init {
    self = [super init];
    
    self.env = @"UAT";
    
    if([self.env isEqualToString:@"UAT"]) {
        self.domain = @"https://www8.qa.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/caseinstall/Simon";
        self.searchAction = @"/MobileAppJSonTest.do";
    } else if ([self.env isEqualToString:@"local"]) {
        self.domain = @"http://hos7d2ua33610jl:9081";
        self.pkmsloginForm = @"/Simon/Main.do?zuser=sydgdxo";
        self.junctionAndSimon = @"/Simon";
        self.searchAction = @"/MobileAppJSonSearch.do";
    } else {
        self.domain = @"https://www8.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/caseinstall/Simon";
        self.searchAction = @"/MobileAppJSonTest.do";
    }
    return self;
}

- (NSURL *) pkmsLoginURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.domain, self.pkmsloginForm]];
    return url;
}

- (NSURL *) searchURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self.domain, self.junctionAndSimon, self.searchAction]];
    return url;
}

- (NSData *) pkmsloginData:(NSString *) userid password:(NSString *) password
{
    NSString *bodyData = [NSString stringWithFormat:@"username=%@&login-form-type=pwd&password=%@&x=0&y=0", userid, password];
    NSData *data = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    return data;
}

- (NSData *) searchData:(NSString *) json
{
    NSString *bodyData = [NSString stringWithFormat:@"json=%@", json];
    NSData *data = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    return data;
}


- (NSMutableURLRequest *) postRequest:(NSURL *) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    return request;
}

- (BOOL) defaultSessionConfiguration
{
    self.sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    if(self.sessionConfig) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) delegateFreeSession
{
    self.session = [NSURLSession sessionWithConfiguration: self.sessionConfig delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    if(self.session) {
        return YES;
    } else {
        return NO;
    }
}

- (MD1SimonResponse *) search:(NSString *)json
{
    MD1SimonResponse *retval = [[MD1SimonResponse alloc] init];
 
    NSMutableURLRequest *request = [self postRequest:[self searchURL]];
    NSData *data = [self searchData:json];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:SEARCH_TIMEOUT];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        //TO DO NSJSONSerialization later for data calls. not here
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
                //taskHelper.responseString <P>Your login was successful.
                NSRange range = [taskHelper.responseString rangeOfString:@"{\"resultset\""];
                if(range.location != NSNotFound){
                    NSError *error;
                    NSObject *json = [NSJSONSerialization JSONObjectWithData:taskHelper.responseData options:0 error:&error];
                    if(!error){
                        retval.data = json;
                    } else {
                        retval.error = [error localizedDescription];
                    }
                } else {
                    NSRange range = [taskHelper.responseString rangeOfString:BUS_ERROR
                                     ];
                    if(range.location != NSNotFound) {
                        retval.error = BUS_ERROR;
                    } else {
                        retval.error = [[NSString alloc] initWithFormat:@"Invalid Server Response:\n%@", taskHelper.responseString];
                    }
                }
                break;
            }
            default:
            {
                retval.error = [taskHelper.error localizedDescription];
                break;
            }
        }
        
    } else {
        [taskHelper.task cancel];
        retval.error = [taskHelper.error localizedDescription];
    }

    return retval;
}

- (MD1SimonResponse *) login:(NSString *) userid password:(NSString *) password
{
    MD1SimonResponse *retval = [[MD1SimonResponse alloc] init];
    
    if(self.isLogin) {
        return retval;
    }
    
    NSMutableURLRequest *request = [self postRequest:[self pkmsLoginURL]];
    NSData *data = [self pkmsloginData:userid password:password];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:LOGIN_TIMEOUT];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        //TO DO NSJSONSerialization later for data calls. not here
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
                if(![self.env isEqualToString:@"local"] ){
                    //taskHelper.responseString <P>Your login was successful.
                    NSRange range = [taskHelper.responseString rangeOfString:@"<P>Your login was successful."];
                    if(range.location != NSNotFound){
                        self.isLogin = YES;
                    } else {
                        retval.error = @"Not Authenticated";
                    }
                } else {
                    self.isLogin = YES;
                }
                break;
            }
            default:
            {
                retval.error = taskHelper.responseString;
                break;
            }
        }
        
    } else {
        NSString *errstr = [taskHelper.error localizedDescription];
        if(errstr) {
            retval.error = errstr;
        } else {
           retval.error = @"Network Timeout";
        }
    }
    return retval;
}
@end
