//
//  MD1EMailViewController.m
//  Workflow
//
//  Created by Dmitry Oreshkin on 10/7/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1AppDelegate.h"
#import "MD1CaseSearchData.h"
#import "MD1EMailViewController.h"

@interface MD1EMailViewController ()

@end


@implementation MD1EMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    NSLog(@"%@", self.CaseSearchDataJSon);
    
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"%@ - %@", self.CaseSearchDataJSon[CSD_PLN_NR], self.CaseSearchDataJSon[CSD_PHD_NM]];
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.CaseSearchDataJSon[CSD_IC_EMAIL]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    if([MFMailComposeViewController canSendMail]) {
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Unable to use Mail API"
                                     message:@""
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
        // shows alert to user
        [notPermitted show];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7@2x.png"] forBarMetrics:UIBarMetricsDefault];
        [self performSegueWithIdentifier:@"unwindToPlanID" sender:self];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail canceled: %@", [error localizedDescription]);
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        default:
            break;
    }
    if(result == MFMailComposeResultFailed) {
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"Mail sent failure"
                                 message:[error localizedDescription]
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        // shows alert to user
        [notPermitted show];
    }
    // Close the Mail Interface
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [self performSegueWithIdentifier:@"unwindToPlanID" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
