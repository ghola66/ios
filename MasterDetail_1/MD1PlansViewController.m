//
//  MD1PlansViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/31/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1CaseSearchData.h"
#import "MD1SimonResponse.h"
#import "MD1SimonSessionHelper.h"
#import "MD1PlansCell.h"
#import "MD1PlansViewController.h"
#import "MD1PlanViewController.h"
#import <HockeySDK/HockeySDK.h>

MD1SimonSessionHelper *g_SimonSession;

@interface MD1PlansViewController ()

- (IBAction)home:(id)sender;
- (IBAction)feedback:(id)sender;

@end

@implementation MD1PlansViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    long retval;
    if(section == 0 ) {
        retval = [self.resultset count];
    } else {
        retval = [self.resultset count];
    }
    return retval;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    
    switch(section) {
        case 0:
        {
            sectionTitle = @"Plan #          Process";
            break;
        }
        case 1:
        {
            sectionTitle = @"Process        Status";
            break;
        }
        case 2:
        {
            sectionTitle = @"";
            break;
        }
        default:
        {
            sectionTitle = @"";
            break;
        }
    }
    return sectionTitle;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if(indexPath.section == 0 ) {
        cellIdentifier = @"PlansData"; //cellIdentifier = @"PlansHeader";
    } else {
        cellIdentifier = @"PlansData";
    }
    
    MD1PlansCell *cell = (MD1PlansCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.section == 0 ) {
        //cell.numberLabel.text = @"Plan #";
        //cell.phNameLabel.text = @"Process";
        NSDictionary  *row = self.resultset[indexPath.row];
        
        NSDictionary *jCSD = row[CSD_JSON];
        NSString *plnNr = (NSString *)jCSD[CSD_PLN_NR];
        NSString *phName = (NSString *)jCSD[CSD_PHD_NM];
        NSString *process = (NSString *)jCSD[CSD_PROC_TYPE_DESC];
        
        cell.numberLabel.text = plnNr;
        cell.phNameLabel.text = phName;
        cell.processLabel.text = process;
    } else {
        NSDictionary  *row = self.resultset[indexPath.row];
        
        NSDictionary *jCSD = row[CSD_JSON];
        NSString *plnNr = (NSString *)jCSD[CSD_PLN_NR];
        NSString *phName = (NSString *)jCSD[CSD_PHD_NM];
        NSString *process = (NSString *)jCSD[CSD_PROC_TYPE_DESC];
        
        cell.numberLabel.text = plnNr;
        cell.phNameLabel.text = phName;
        cell.processLabel.text = process;
    }
    
    return cell;
}

- (IBAction)home:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)feedback:(id)sender {
#if GGS_ENV==UAT
    [[[BITHockeyManager sharedHockeyManager] feedbackManager] showFeedbackComposeView];
#endif
}

- (IBAction)listFeedback:(id)sender {
#if GGS_ENV==UAT
    [[[BITHockeyManager sharedHockeyManager] feedbackManager] showFeedbackListView];
#endif
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowPlan"]) {
        
        MD1PlansCell *cell = sender;
        UITableView *table = (UITableView *)cell.superview.superview;
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        NSDictionary  *row = self.resultset[indexPath.row];
        NSDictionary *jCSD = row[CSD_JSON];
        NSString *caseNr = (NSString *)jCSD[CSD_CASE_NR];
        
        NSLog(@"caseNr:%@\n", caseNr);
        
        BOOL performSegue = NO;
        NSString *error;
        
        NSMutableDictionary *jsonIn = [[NSMutableDictionary alloc] init];
            jsonIn[CSD_CASE_NR] = caseNr;
        
        NSError *nserror;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(jsonIn) options:0 error:&nserror];
        
        if(!nserror) {
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            MD1SimonResponse *response;
            response = [g_SimonSession getCase:jsonStr];
            
            if (!response.error) {
                NSObject *jsonOut = response.data;
                if(jsonOut) {
                    NSDictionary *jsonDic = (NSDictionary *)jsonOut;
                    NSArray *resultset = [jsonDic objectForKey:@"resultset"];
                    if(resultset) {
                        self.caseResultset = resultset;
                        performSegue = YES;
                    } else {
                        error = @"Invalid System Response, resultset=(nil)";
                        [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
                    }
                } else {
                    error = @"Invalid System Response, data=(nil)";
                    [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
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
            [NSString stringWithFormat:@"%@\n\n%@", [MD1SimonSessionHelper getUserError:self.userGroup], error];
        }
        
        if (!performSegue) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
        }
        return performSegue;
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSDictionary  *row = self.caseResultset[0];
    NSDictionary *jCSD = row[CSD_JSON];
    MD1PlanViewController *targetvc =[segue destinationViewController];
    targetvc.userGroup = _userGroup;
    [targetvc segueData:jCSD];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
