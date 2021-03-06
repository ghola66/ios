//
//  MD1AppDelegate.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/21/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1AppDelegate.h"
#import "MD1SimonSessionHelper.h"

#ifdef GGS_HOCKEY
//#import <HockeySDK/HockeySDK.h>


#if GGS_ENV==GGS_ENV_PROD
#define GGS_HOCKEY_ID @"60e06067c9cf3b23e902c925c5c89759"
#elif GGS_ENV==GGS_ENV_UAT
#define GGS_HOCKEY_ID @"bd098a0f3092c287f3aa8d831bfaf130"
#elif GGS_ENV==GGS_ENV_LOCAL
#define GGS_HOCKEY_ID @"bd098a0f3092c287f3aa8d831bfaf130"
#endif

#endif

MD1SimonSessionHelper *g_SimonSession;

@implementation MD1AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
#ifdef GGS_HOCKEY
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:GGS_HOCKEY_ID];
//    [[BITHockeyManager sharedHockeyManager] startManager];
//    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
#endif
    
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7@2x.png"]   forBarMetrics:UIBarMetricsDefault];
    
    g_SimonSession = [[MD1SimonSessionHelper alloc] init];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
