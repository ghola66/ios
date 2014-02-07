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

@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *password;
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
    }
    
    // by default perform the segue transition
    return YES;
}
@end
