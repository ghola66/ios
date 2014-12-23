//
//  MD1LoginViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>

#import "MD1SimonSessionHelper.h"
#import "MD1LoginViewController.h"
#import "RGO.h"
#import "SalesRep.h"
#import "MD1SearchViewController.h"
#import "MD1PlansViewController.h"

#ifdef GGS_HOCKEY
#import <HockeySDK/HockeySDK.h>
#endif

MD1SimonSessionHelper *g_SimonSession;

@interface MD1LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *dataFilePath;
@property (strong, nonatomic) NSArray *RGOs;
@property (strong, nonatomic) NSDictionary *salesReps;
@property (strong, nonatomic) NSDate *cacheDate;
@property (strong, nonatomic) NSString *userGroup;
@property (strong, nonatomic) NSString *tmpid;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *legal;

@property (weak, nonatomic) IBOutlet UIButton *feedbackB;
@property (weak, nonatomic) IBOutlet UIButton *showFeedbackB;

@property (nonatomic, assign) id currentResponder;

@end

@implementation MD1LoginViewController

BOOL isFirstAppearance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstAppearance = YES;
    
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    //self.hidesBottomBarWhenPushed = YES;
    self.navigationController.toolbarHidden = YES;
    
#ifndef GGS_HOCKEY
    self.feedbackB.hidden = YES;
    self.showFeedbackB.hidden = YES;
#endif
    
    {
        NSMutableDictionary *data = [MD1LoginViewController keyChainLoadKey:@"simonlogin"];
        if(data != nil) {
            _tmpid = data[@"userid"];
            _userid.text = _tmpid;
            _password.text = data[@"password"];
        }
    }

    {
        NSFileManager *filemgr;
        NSString *docsDir;
        NSArray *dirPaths;
        filemgr = [NSFileManager defaultManager];
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        // Build the path to the data file
        _dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"guardian_simon.archive"]];
        // Check if the file already exists
        if ([filemgr fileExistsAtPath: _dataFilePath]){
            NSMutableArray *dataArray;
            dataArray = [NSKeyedUnarchiver
                         unarchiveObjectWithFile: _dataFilePath];
            NSLog(@"got stored objects:%lu", (unsigned long)[dataArray count]);
            if([dataArray count] == 4 ){
                _userGroup = dataArray[0];
                _RGOs = dataArray[1];
                _salesReps = dataArray[2];
                _cacheDate = dataArray[3];
            } else {
                NSLog(@"expecting 4 but got:%lu objects", (unsigned long)[dataArray count]);
                NSLog(@"group:%@", _userGroup);
            }
        } else {
            NSLog(@"did not find guardian_simon.archive");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)legal:(id)sender {
    NSString* launchUrl = @"https://www.guardiananytime.com/fpapp/FPWeb/disclaimers.jsp";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

-(IBAction)passwordFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    if ([sender isEqual:self.password]) {
        if([self shouldPerformSegueWithIdentifier:@"ShowSearch" sender:self]) {
            [self performSegueWithIdentifier:@"ShowSearch" sender:self];
        }
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowSearch"]) {
        // perform your computation to determine whether segue should occur
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        MD1SimonResponse *response;
        
        if(![self.userid.text isEqualToString:_tmpid]) {
            _userGroup = nil;
            _RGOs = nil;
            _salesReps = nil;
            _tmpid = self.userid.text;
            [g_SimonSession invalidateWebseal];
        }
        
        if( [self.userid.text length] == 0 || [self.password.text length] == 0) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:@"Please enter ID and password"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
        
        
        response = [g_SimonSession login:self.userid.text password:self.password.text];
        
        if (response.error) {
            
            NSString *error = nil;
            if(response.isAuthFailed) {
                error = response.error;
            } else {
                error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], response.error];
            }
            
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            [g_SimonSession invalidateWebseal];
            return NO;
        }
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        data[@"userid"] = _userid.text;
        data[@"password"] = _password.text;
        
        [MD1LoginViewController keyChainSaveKey:@"simonlogin" data:data];
        
        if(_cacheDate != nil) {
            NSInteger days = [MD1LoginViewController daysBetweenDate:_cacheDate andDate:[NSDate date]];
            NSLog(@"days between casche:%ld", (long)days);
            if(days > 0) {
                _RGOs = nil;
            }
        }
        
        if(_RGOs == nil){
            MD1SimonResponse *response = [g_SimonSession getStaticData];
            if (response.error) {
                NSString *error = nil;
                if(response.isSessExp) {
                    error = response.error;
                } else {
                    error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], response.error];
                }
                
                UIAlertView *notPermitted = [[UIAlertView alloc]
                                             initWithTitle:@"Error"
                                             message:error
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                
                // shows alert to user
                [notPermitted show];
                
                // prevent segue from occurring
                [g_SimonSession invalidateWebseal];
                return NO;
            }
        
            NSObject *jsonOut = response.data;
            NSDictionary *jsonDic = (NSDictionary *)jsonOut;
            NSDictionary *resultset = [jsonDic objectForKey:@"resultset"];
            
            _userGroup = [resultset objectForKey:@"group"];
            _RGOs = [resultset objectForKey:@"RGOs"];
            _salesReps = [resultset objectForKey:@"salesReps"];
        }
        
        BOOL dataerror = NO;
        @try{
            [dataArray addObject:_userGroup];
            
            for(int i = 0; i < _RGOs.count; i++)
            {
                NSDictionary *rgo = _RGOs[i];
                NSArray *allKeys = [rgo allKeys];
                NSString *key = allKeys[0];
                NSString *value = rgo[key];
                RGO *rgocn = [RGO new];
                rgocn.cd = key;
                rgocn.name = value;
                g_SimonSession.RGOs[i] = rgocn;
            }
            
            
            NSArray *akeys = [_salesReps allKeys];
            for(NSString *key in akeys)
            {
                NSArray *jReps = _salesReps[key];
                NSMutableArray *reps = [[NSMutableArray alloc] init];
                for(NSDictionary *jRep in jReps) {
                    SalesRep *rep = [SalesRep new];
                    rep.racfid = jRep[@"racfid"];
                    rep.fullNm = jRep[@"fullNm"];
                    [reps addObject:rep];
                }
                g_SimonSession.salesReps[key] = reps;
            }
        }
        @catch(NSException *e) {
            NSLog(@"NSException:%@", e);
            
            NSString *error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], e];
            dataerror = YES;
            _RGOs = nil;
            _salesReps = nil;
            _userGroup = nil;
            
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            [dataArray removeAllObjects];
            [dataArray addObject:[NSNull null]];
            
            if([NSKeyedArchiver archiveRootObject:dataArray toFile:_dataFilePath]) {
                
                NSError* error;
                NSDictionary *fileAttributes = [NSDictionary
                                                dictionaryWithObject:NSFileProtectionComplete
                                                forKey:NSFileProtectionKey];
                if([[NSFileManager defaultManager] setAttributes:fileAttributes
                                                    ofItemAtPath:_dataFilePath  error: &error]) {
                    NSLog(@"Success to use NSFileProtectionComplete");
                }
                else {
                    NSLog(@"%@", error);
                }
            }

            
            // prevent segue from occurring
            [g_SimonSession invalidateWebseal];
            return NO;
        }
        
        [dataArray addObject:_RGOs];
        [dataArray addObject:_salesReps];
        _cacheDate = [NSDate date];
        [dataArray addObject:_cacheDate];
        
        
        
        
        if([NSKeyedArchiver archiveRootObject:dataArray toFile:_dataFilePath]) {
            
            NSError* error;
            NSDictionary *fileAttributes = [NSDictionary
                                            dictionaryWithObject:NSFileProtectionComplete
                                            forKey:NSFileProtectionKey];
            if([[NSFileManager defaultManager] setAttributes:fileAttributes
                                                ofItemAtPath:_dataFilePath  error: &error]) {
                NSLog(@"Success to use NSFileProtectionComplete");
            }
            else {
                NSLog(@"%@", error);
            }
        }

        if([_userGroup isEqualToString:@"case_install_mobile_user"] || [_userGroup isEqualToString:@"case_install_mobile_usr"]) {
            return YES;
        } else {
            BOOL performSegue = NO;
            NSString *error, *errTitle;
            
            NSMutableDictionary *jsonIn = [[NSMutableDictionary alloc] init];
            
            NSError *nserror;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(jsonIn) options:0 error:&nserror];
            
            errTitle = @"Error";
            
            if(!nserror) {
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                MD1SimonResponse *response;
                response = [g_SimonSession search:jsonStr];
                
                if (!response.error) {
                    NSObject *jsonOut = response.data;
                    if(jsonOut) {
                        NSDictionary *jsonDic = (NSDictionary *)jsonOut;
                        NSArray *resultset = [jsonDic objectForKey:@"resultset"];
                        if(resultset) {
                            if([resultset count] > 0) {
                                self.resultset = resultset;
                                performSegue = YES;
                            } else {
                                performSegue = NO;
                                errTitle = @"Warning";
                                error = @"No customer applications currently found";
                            }
                            
                        } else {
                            error = @"Invalid System Response, resultset=(nil)";
                            error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
                        }
                    } else {
                        error = @"Invalid System Response, data=(nil)";
                        error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
                    }
                } else {
                    if(response.isSessExp) {
                        error = response.error;
                    } else {
                        error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], response.error];
                    }
                }
            } else {
                error = [nserror localizedDescription];
                error = [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
            }
            
            if (!performSegue) {
               [self performSegueWithIdentifier:@"showbrokernoplansID" sender:self];
            } else {
                [self performSegueWithIdentifier:@"showbrokerplansID" sender:self];
            }
            
            return NO;

        }
        
    } else if([identifier isEqualToString:@"showbrokernoplansID"]){
        
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[MD1SearchViewController class]]) {
        MD1SearchViewController *targetvc =[segue destinationViewController];
        targetvc.userid = self.userid.text;
        targetvc.userGroup = _userGroup;
    } else if([[segue destinationViewController] isKindOfClass:[MD1PlansViewController class]]) {
        MD1PlansViewController *targetvc =[segue destinationViewController];
        targetvc.userGroup = _userGroup;
        targetvc.resultset = self.resultset;
    }
}

- (IBAction) unwindToLogin: (UIStoryboardSegue *)segue {
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
 }

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self performSegueWithIdentifier:@"showlegal" sender:self];
    
    if (isFirstAppearance) {
        //NSLog(@"root view controller is moving to parent");
        isFirstAppearance = NO;
    }else{
        //NSLog(@"root view controller, not moving to parent");
        [g_SimonSession invalidateWebseal];
    }
}

- (IBAction)feedback:(id)sender {
#ifdef GGS_HOCKEY
    [[[BITHockeyManager sharedHockeyManager] feedbackManager] showFeedbackComposeView];
#endif
}

- (IBAction)listFeedback:(id)sender {
#ifdef GGS_HOCKEY
    [[[BITHockeyManager sharedHockeyManager] feedbackManager] showFeedbackListView];
#endif
}
+ (void)keyChainSaveKey:(NSString *)key data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)keyChainLoadKey:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e) {
            //NS Log(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally {}
    }
    if (keyData) CFRelease(keyData);
    return ret;
}

+ (void)keyChainDeleteKey:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

//helper
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            key, (__bridge id)kSecAttrService,
            key, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            nil];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end