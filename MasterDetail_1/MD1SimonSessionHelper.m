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

BOOL isValid;

- (MD1SimonSessionHelper *) init {
    self = [super init];
    
    self.env = @"PROD";
    
#if GGS_ENV==GGS_ENV_PROD
    self.env = @"PROD";
#elif GGS_ENV==GGS_ENV_UAT
    self.env = @"UAT";
#elif GGS_ENV==GGS_ENV_LOCAL
    self.env = @"local";
#endif
    
    if([self.env isEqualToString:@"UAT"]) {
        self.domain = @"https://www8.qa.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/caseinstall/Simon";
    } else if ([self.env isEqualToString:@"local"]) {
        self.domain = @"http://hos7d2ua33610jl:9081";
        self.pkmsloginForm = @"/Simon/MobileAppJSonLocalLogin.do?mobile=true&zuser=";
        self.junctionAndSimon = @"/Simon";
    } else if ([self.env isEqualToString:@"SIT2"]) {
        self.domain = @"https://cesit.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/cisit/Simon";
    } else if ([self.env isEqualToString:@"SIT"]) {
        self.domain = @"https://cesit.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/caseinstall/Simon";
    } else {
        self.domain = @"https://www8.glic.com";
        self.pkmsloginForm = @"/pkmslogin.form";
        self.junctionAndSimon = @"/caseinstall/Simon";
    }
    self.searchAction = @"/MobileAppJSonSearch.do?mobile=true";
    self.caseAction = @"/MobileAppJSonCase.do?mobile=true";
    self.staticDataAction = @"/MobileAppJSonStaticData.do?mobile=true";

    
    self.RGOs = [[NSMutableArray alloc] init];
    self.salesReps  = [[NSMutableDictionary alloc] init];
                       
    return self;
}

- (NSURL *) pkmsLoginURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.domain, self.pkmsloginForm]];
    return url;
}

- (NSURL *) pkmsLoginURL:(NSString *) userid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self.domain, self.pkmsloginForm, userid]];
    return url;
}

- (NSURL *) searchURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self.domain, self.junctionAndSimon, self.searchAction]];
    return url;
}

- (NSURL *) caseURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self.domain, self.junctionAndSimon, self.caseAction]];
    return url;
}


- (NSURL *) getStaticDataURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self.domain, self.junctionAndSimon, self.staticDataAction]];
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

- (NSData *) caseData:(NSString *) json
{
    NSString *bodyData = [NSString stringWithFormat:@"json=%@", json];
    NSData *data = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    return data;
}

- (NSData *) getStaticDataData
{
    NSString *bodyData = [NSString stringWithFormat:@"json=\"\""];
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
        isValid = YES;
        return YES;
    } else {
        isValid = NO;
        return NO;
    }
}

- (void) invalidateWebseal {
    //[self.session invalidateAndCancel];
    //self.session = nil;
    //isValid = NO;
    self.isLogin = NO;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[self pkmsLoginURL]];
    for (NSHTTPCookie *cookie in cookies)
    {
        NSLog(@"found:%@", cookie);
        if([[cookie name] isEqualToString:@"PD-S-SESSION-ID"] || [[cookie name] isEqualToString:@"PD-H-SESSION-ID"] || [[cookie name] isEqualToString:@"PD-ID"] || [[cookie name] isEqualToString:@"JSESSIONID"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            NSLog(@"removed:%@", cookie);
        }
    }
}

- (MD1SimonResponse *) search:(NSString *)json
{
    MD1SimonResponse *retval = [[MD1SimonResponse alloc] init];
    
    if(isValid == NO) {
        retval.error = @"Lost connection to Guardian";
        return retval;
    }
 
    NSMutableURLRequest *request = [self postRequest:[self searchURL]];
    NSData *data = [self searchData:json];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:SEARCH_TIMEOUT msg:@"Searching"];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
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
                    NSRange range = [taskHelper.responseString rangeOfString:BUS_ERROR];
                    if(range.location != NSNotFound) {
                        retval.error = @"Server returned generic error"; //BUS_ERROR;
                    } else if([taskHelper.responseString rangeOfString:XPIRE_MSG].location != NSNotFound) {
                        self.isLogin = NO;
                        self.isRefresh = YES;
                        retval.error = @"Session expired. Please login again";
                        retval.isSessExp = YES;
                    }
                    else {
                        retval.error = [[NSString alloc] initWithFormat:@"Invalid Server Response:\n%@", taskHelper.responseString];
                    }
                }
                break;
            }
            case 500:
            {
                retval.error = @"500 Internal Server Error";
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


- (MD1SimonResponse *) getCase:(NSString *)json
{
    MD1SimonResponse *retval = [[MD1SimonResponse alloc] init];
    
    NSMutableURLRequest *request = [self postRequest:[self caseURL]];
    NSData *data = [self searchData:json];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:SEARCH_TIMEOUT msg:@"Getting Plan Data"];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
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
                    NSRange range = [taskHelper.responseString rangeOfString:BUS_ERROR];
                    if(range.location != NSNotFound) {
                        retval.error = @"Server returned generic error"; //BUS_ERROR;
                    } else if([taskHelper.responseString rangeOfString:XPIRE_MSG].location != NSNotFound) {
                        self.isLogin = NO;
                        self.isRefresh = YES;
                        retval.error = @"Session expired. Please login again";
                        retval.isSessExp = YES;
                    }
                    else {
                        retval.error = [[NSString alloc] initWithFormat:@"Invalid Server Response:\n%@", taskHelper.responseString];
                    }
                }
                break;
            }
            case 500:
            {
                retval.error = @"500 Internal Server Error";
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
    
    NSURL *loginURL;
    if([self.env isEqualToString:@"local"]) {
        loginURL = [self pkmsLoginURL:userid];
    } else {
        loginURL = [self pkmsLoginURL];
    }
    
    NSMutableURLRequest *request = [self postRequest:loginURL];
    NSData *data = [self pkmsloginData:userid password:password];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:LOGIN_TIMEOUT msg:@"Authenticating"];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        //TO DO NSJSONSerialization later for data calls. not here
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
                if(![self.env isEqualToString:@"local"] ){
                    NSRange range = [taskHelper.responseString rangeOfString:@"<P>Your login was successful."];
                    if(range.location != NSNotFound){
                        self.isLogin = YES;
                    } else {
                        NSRange range = [taskHelper.responseString rangeOfString:XPIRE_MSG];
                        if(range.location == NSNotFound){
                            self.isLogin = YES;
                        } else {
                            retval.isAuthFailed = YES;
                            retval.error = @"Your user id and/or password are not recognized.  If you are a registered GuardianAnytime user, please try again.  If you are not registered, please go to www.guardiananytime.com to sign up now.  You will need your commission statement to register.";
                        }
                    }
                } else {
                    self.isLogin = YES;
                }
                break;
            }
            case 500:
            {
                retval.error = @"500 Internal Server Error";
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

- (MD1SimonResponse *) getStaticData
{
    MD1SimonResponse *retval = [[MD1SimonResponse alloc] init];
    
    NSMutableURLRequest *request = [self postRequest:[self getStaticDataURL]];
    NSData *data = [self getStaticDataData];
    
    MD1SimonTaskHelper *taskHelper = [[MD1SimonTaskHelper alloc] init];
    
    [taskHelper startSync:self.session request:request data:data wait:SEARCH_TIMEOUT msg:@"Getting Application Data"];
    
    if(taskHelper.task.state == NSURLSessionTaskStateCompleted && !taskHelper.error) {
        NSInteger nscode = [taskHelper.httpResponse statusCode];
        long code = nscode;
        
        switch(code)
        {
            case 200:
            {
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
                    NSRange range = [taskHelper.responseString rangeOfString:BUS_ERROR];
                    if(range.location != NSNotFound) {
                        retval.error = @"Server returned generic error"; //BUS_ERROR;
                    } else if([taskHelper.responseString rangeOfString:XPIRE_MSG].location != NSNotFound) {
                        self.isLogin = NO;
                        self.isRefresh = YES;
                        retval.error = @"Session expired. Please login again";
                        retval.isSessExp = YES;
                    }
                    else {
                        retval.error = [[NSString alloc] initWithFormat:@"Invalid Server Response:\n%@", taskHelper.responseString];
                    }
                }
                break;
            }
            case 500:
            {
                retval.error = @"500 Internal Server Error";
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

+ (BOOL) isBroker:(NSString *) group {
    if([group isEqualToString:BROKER_GROUP]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *) getUserError:(NSString *) group {
    if([MD1SimonSessionHelper isBroker:group]) {
        return CRU_ERROR;
    } else {
        return BUS_ERROR;
    }
}


@end
