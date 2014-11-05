//
//  MD1SimonResponse.h
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/4/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD1SimonResponse : NSObject

@property NSObject *data;
@property NSString *error;
@property BOOL isAuthFailed;
@property BOOL isSessExp;

@end
