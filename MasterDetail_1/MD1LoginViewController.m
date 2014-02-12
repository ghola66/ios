//
//  MD1LoginViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1SimonSessionHelper.h"
#import "MD1LoginViewController.h"

MD1SimonSessionHelper *g_SimonSession;

@interface MD1LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userid;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *dataFilePath;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *go;

- (IBAction)go:(id)sender;

@end

@implementation MD1LoginViewController

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
    self.logo.image  = [UIImage imageNamed:@"guardian-logo.gif"];
    
    {
        NSFileManager *filemgr;
        NSString *docsDir;
        NSArray *dirPaths;
        filemgr = [NSFileManager defaultManager];
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        // Build the path to the data file
        _dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"guardian.archive"]];
        // Check if the file already exists
        if ([filemgr fileExistsAtPath: _dataFilePath]){
            NSMutableArray *dataArray;
            dataArray = [NSKeyedUnarchiver
                         unarchiveObjectWithFile: _dataFilePath];
            _userid.text = dataArray[0];
            _password.text = dataArray[1];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender
{
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

-(IBAction)passwordFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    /*if ([sender isEqual:self.password]) {
     [self.go sendActionsForControlEvents:UIControlEventTouchUpInside];
    }*/
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
        
        MD1SimonResponse *response;
        
        response = [g_SimonSession login:self.userid.text password:self.password.text];
        
        if (response.error) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:response.error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
        
        {
            NSMutableArray *dataArray;
            dataArray = [[NSMutableArray alloc] init];
            [dataArray addObject:_userid.text];
            [dataArray addObject:_password.text];
            [NSKeyedArchiver archiveRootObject:dataArray toFile:_dataFilePath];
        }
        
        {
            MD1SimonResponse *response = [g_SimonSession getStaticData];
            if (response.error) {
                UIAlertView *notPermitted = [[UIAlertView alloc]
                                             initWithTitle:@"Error"
                                             message:response.error
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                
                // shows alert to user
                [notPermitted show];
                
                // prevent segue from occurring
                return NO;
            }
            
            {
                NSObject *jsonOut = response.data;
                NSDictionary *jsonDic = (NSDictionary *)jsonOut;
                NSDictionary *resultset = [jsonDic objectForKey:@"resultset"];
                NSArray *RGOs = [resultset objectForKey:@"RGOs"];
                NSArray *salesReps = [resultset objectForKey:@"salesReps"];
                
                for(int i = 0; i < RGOs.count; i++)
                {
                    NSDictionary *rgo = RGOs[i];
                    NSArray *allKeys = [rgo allKeys];
                    NSString *key = allKeys[0];
                    NSString *value = rgo[key];
                    g_SimonSession.RGOs[i] = [[NSString alloc] initWithFormat:@"%@ - %@", key, value];
                }
                
                for(int i = 0; i < salesReps.count; i++)
                {
                    NSDictionary *sr = salesReps[i];
                    NSArray *allKeys = [sr allKeys];
                    NSString *key = allKeys[0];
                    NSString *value = sr[key];
                    g_SimonSession.salesReps[i] = [[NSString alloc] initWithFormat:@"%@ - %@", key, value];
                }
            }
        }

    }

    // by default perform the segue transition
    return YES;
}
@end
