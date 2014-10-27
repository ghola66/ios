//
//  MD1SearchViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1CaseSearchData.h"
#import "MD1SimonResponse.h"
#import "MD1SimonSessionHelper.h"
#import "MD1SearchViewController.h"
#import "MD1PlansViewController.h"
#import "RGOTableViewController.h"
#import "SRTableViewController.h"


MD1SimonSessionHelper *g_SimonSession;


@interface MD1SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *RGOtext;
@property (weak, nonatomic) IBOutlet UITextField *salesRepText;
@property (weak, nonatomic) IBOutlet UITextField *planNumber;
@property (weak, nonatomic) IBOutlet UITextField *planholder;
@property (weak, nonatomic) IBOutlet UISwitch *matchAnywhere;
@property BOOL RGOtextClr;
@property BOOL SRtextClr;
@property (nonatomic) NSMutableArray *salesReps;
@property (nonatomic, assign) id currentResponder;

- (IBAction)home:(id)sender;
- (IBAction)clear:(id)sender;

@end

@implementation MD1SearchViewController

    RGO *RGOselected;
    SalesRep *SRselected;

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
    // Do any additional setup after loading the view.
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    self.RGOtextClr = NO;
    self.SRtextClr = NO;
    
    /*
    if([_userGroup isEqualToString:@"Group_producer"]){
        if([self shouldPerformSegueWithIdentifier:@"ShowPlans" sender:self]){
            [self performSegueWithIdentifier:@"ShowPlans" sender:self];
            return;
        }
    }
    */
    
    NSString *racfid = _userid;
    BOOL idfound = NO;
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(racfid =[cd] %@)", racfid];
    
    for(NSString *key in g_SimonSession.salesReps) {
        NSArray *array = g_SimonSession.salesReps[key];
        NSArray *matches = [array filteredArrayUsingPredicate:resultPredicate];
        if([matches count] > 0) {
            idfound = YES;
            SRselected = matches[0];
            break;
        }
    }
    
    if(idfound) {
        _salesRepText.text = SRselected.fullNm;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search:(id)sender
{
}

- (IBAction)home:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)clear:(id)sender
{
    self.planNumber.text = @"";
    self.planholder.text = @"";
    self.matchAnywhere.on = NO;
    self.salesRepText.text = @"";
    self.RGOtext.text = @"";
    RGOselected = nil;
    SRselected = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[MD1PlansViewController class]]) {
        MD1PlansViewController *targetvc =[segue destinationViewController];
        targetvc.resultset = self.resultset;
    } else if([[segue destinationViewController] isKindOfClass:[RGOTableViewController class]]) {
        RGOTableViewController *targetvc =[segue destinationViewController];
        targetvc.RGOs = g_SimonSession.RGOs;
    } else if([[segue destinationViewController] isKindOfClass:[SRTableViewController class]]) {
        SRTableViewController *targetvc =[segue destinationViewController];
        targetvc.SalesReps = g_SimonSession.salesReps;
    } else {
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowPlans"]) {
        BOOL performSegue = NO;
        NSString *error, *errTitle;
        
        NSMutableDictionary *jsonIn = [[NSMutableDictionary alloc] init];
        if([self.planNumber.text length] > 0) {
            NSString *plnNr = self.planNumber.text;
            if([plnNr length] < 8) {
                NSString *padding = [@"" stringByPaddingToLength:8 - [plnNr length]  withString:@"0" startingAtIndex:0];
                plnNr = [padding stringByAppendingString:plnNr];
            }
            jsonIn[CSD_PLN_NR] = plnNr;
        }
        if([self.planholder.text length] > 0) {
            jsonIn[CSD_PHD_NM] = self.planholder.text;
        }
        if(self.matchAnywhere.on) {
            jsonIn[@"isPHMatch"] = @"true";
        }
        if(SRselected != nil) {
            jsonIn[CSD_SALES_REP_CD] = SRselected.racfid;
        }
        if(RGOselected != nil) {
            jsonIn[CSD_RGO_CD] = RGOselected.cd;
        }
        
        if([jsonIn count] == 0) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Warning"
                                         message:@"Please enter search criteria"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            return NO;
        }
        
        NSError *nserror;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(jsonIn) options:0 error:&nserror];
        
        errTitle = @"Error";
        
        if(!nserror) {
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            self.resultset = nil;
            
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
                    }
                } else {
                    error = @"Invalid System Response, data=(nil)";
                }
            } else {
                error = response.error;
            }
        } else {
            error = [nserror localizedDescription];
        }
        
        if (!performSegue) {
            NSLog(@"%@", error);
            error = [MD1SimonSessionHelper getUserError:self.userGroup];
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:errTitle
                                         message:error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
        }
        return performSegue;
    }
    
    // by default perform the segue transition
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField isEqual:self.planNumber] || [textField isEqual:self.planholder]) {
        if([self shouldPerformSegueWithIdentifier:@"ShowPlans" sender:self]){
            [self performSegueWithIdentifier:@"ShowPlans" sender:self];
        }
    }
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.RGOtext] ) {
        [textField resignFirstResponder];
        if(self.RGOtextClr == NO) {
            [self performSegueWithIdentifier:@"showrgos" sender:self];
        } else {
            self.RGOtextClr = NO;
        }
        return NO;
    } else if([textField isEqual:self.salesRepText] ) {
        [textField resignFirstResponder];
        if(self.SRtextClr == NO) {
            [self performSegueWithIdentifier:@"showsalesreps" sender:self];
        } else {
            self.SRtextClr = NO;
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if([textField isEqual:self.RGOtext] ) {
        self.RGOtext.text = @"";
        RGOselected = nil;
        self.RGOtextClr = YES;
    } else if([textField isEqual:self.salesRepText] ) {
        self.salesRepText.text = @"";
        SRselected = nil;
        self.SRtextClr = YES;
    }
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (IBAction) unwindToSearch: (UIStoryboardSegue *)segue {
    
    if([[segue sourceViewController] isKindOfClass:[RGOTableViewController class]]) {
        RGOTableViewController *sourceVC = [segue sourceViewController];
        RGOselected = sourceVC.RGOselected;
        self.RGOtext.text = [NSString stringWithFormat:@"%@ - %@", sourceVC.RGOselected.cd, sourceVC.RGOselected.name];
    } else if([[segue sourceViewController] isKindOfClass:[SRTableViewController class]]) {
        SRTableViewController *sourceVC = [segue sourceViewController];
        SRselected = sourceVC.SRselected;
        self.salesRepText.text = [NSString stringWithFormat:@"%@", sourceVC.SRselected.fullNm];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
  }

@end
