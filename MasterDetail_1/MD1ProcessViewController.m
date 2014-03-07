//
//  MD1ProcessViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/5/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1ProcessCell.h"
#import "MD1CaseSearchData.h"
#import "MD1ProcessViewController.h"

@interface MD1ProcessViewController ()

@property NSMutableArray *processInfoOrder;
@property NSMutableArray *processTitleOrder;

- (IBAction)home:(id)sender;

@end

@implementation MD1ProcessViewController

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
    
    self.processInfoOrder = [[NSMutableArray alloc] init];
    self.processInfoOrder[0] = CSD_CASE_NR;
    self.processInfoOrder[1] = CSD_PROC_TYPE_DESC;
    self.processInfoOrder[2] = CSD_OWNR_NM;
    self.processInfoOrder[3] = CSD_CASE_STATUS_DESC;
    self.processInfoOrder[4] = CSD_CASE_START_DT;
    self.processInfoOrder[5] = CSD_TERM_DT;
    
    
    self.processTitleOrder = [[NSMutableArray alloc] init];
    self.processTitleOrder[0] = @"Process ID:";
    self.processTitleOrder[1] = @"Process:";
    self.processTitleOrder[2] = @"Onboarder:";
    self.processTitleOrder[3] = @"Status:";
    self.processTitleOrder[4] = @"Initiated:";
    self.processTitleOrder[5] = @"Completed:";
    self.processTitleOrder[6] = @"Tasks";
    self.processTitleOrder[7] = @"  Risk Assumed";
    self.processTitleOrder[8] = @"  eBooks Delivered";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) segueData:(NSDictionary *)processData
{
    self.processData = processData;
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
    return [self.processData count] + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProcessData";
    MD1ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.keyLabel.text = self.processTitleOrder[indexPath.row];
    if(indexPath.row == 0) {
        NSNumber *caseNr = self.processData[self.processInfoOrder[indexPath.row]];
        cell.valueLabel.text = [[NSString alloc] initWithFormat:@"%@", caseNr];
    } else if (indexPath.row <= 5) {
        cell.valueLabel.text = self.processData[self.processInfoOrder[indexPath.row]];
    } else {
        switch(indexPath.row) {
            case 6: {
                cell.valueLabel.text = @"Status";
                [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
                break;
            }
            case 7: {
                cell.valueLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }
            case 8: {
                cell.valueLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }
        }
    }
    
    return cell;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction) unwindToProcess: (UIStoryboardSegue *)segue {
    if(YES) {
    
    }
}

- (IBAction)home:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
