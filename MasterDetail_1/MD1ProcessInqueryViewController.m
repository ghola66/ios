//
//  MD1ProcessInqueryViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/10/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GCPlaceholderTextView.h"
#import "MD1SimonResponse.h"
#import "MD1SimonSessionHelper.h"
#import "MD1ProcessInqueryViewController.h"

MD1SimonSessionHelper *g_SimonSession;

@interface MD1ProcessInqueryViewController ()

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *inquiry;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submit;

- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;


@end

@implementation MD1ProcessInqueryViewController

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
    self.inquiry.layer.borderColor = [UIColor grayColor].CGColor;
    self.inquiry.layer.borderWidth =  1.0f;
    //self.inquiry.layer.cornerRadius = 5.0f;
    self.inquiry.layer.masksToBounds = YES;
    
    self.inquiry.placeholder = @"Tap here in order to enter inquiry";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue, segue:%@, sender:%@", segue, sender);
    
    return;
}

- (IBAction)submit:(id)sender
{
    MD1SimonResponse *response;
    response = [g_SimonSession submitInquiry:self.view];
    
    if (!response.error) {
        UIAlertView *inquirySent = [[UIAlertView alloc]
                                    initWithTitle:@"Inquiry Sent"
                                    message:nil
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        
        // shows alert to user
        [inquirySent show];
    } else {
        UIAlertView *inquiryError = [[UIAlertView alloc]
                                    initWithTitle:@"Failed to send Inquiry. Please try again later"
                                    message:response.error
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        
        // shows alert to user
        [inquiryError show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
