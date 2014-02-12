//
//  MD1PlanViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/5/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1CaseSearchData.h"
#import "MD1PlanCell.h"
#import "MD1ProcessesCell.h"
#import "MD1PlanViewController.h"
#import "MD1ProcessViewController.h"

@interface MD1PlanViewController ()

@property NSMutableArray *planInfoOrder;
@property NSMutableArray *planTitleOrder;

- (IBAction)home:(id)sender;

@end

@implementation MD1PlanViewController

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
    
    self.planInfoOrder = [[NSMutableArray alloc] init];
    self.planInfoOrder[0] = CSD_PLN_NR;
    self.planInfoOrder[1] = CSD_PHD_NM;
    self.planInfoOrder[2] = CSD_SITUS_ST;
    self.planInfoOrder[3] = CSD_RGO_NM;
    self.planInfoOrder[4] = CSD_SALES_REP_NM;
    self.planInfoOrder[5] = CSD_SSA;
    self.planInfoOrder[6] = CSD_PROC_TEAM_NM;
    self.planInfoOrder[7] = CSD_TOTAL_ELIG_LVS_CT;
    
    self.planTitleOrder = [[NSMutableArray alloc] init];
    self.planTitleOrder[0] = @"Plan #";
    self.planTitleOrder[1] = @"Planholder";
    self.planTitleOrder[2] = @"Situs State";
    self.planTitleOrder[3] = @"RGO";
    self.planTitleOrder[4] = @"Sales Rep";
    self.planTitleOrder[5] = @"SSA";
    self.planTitleOrder[6] = @"Onboarding Specialist";
    self.planTitleOrder[7] = @"Total Eligible Lives";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) segueData:(NSDictionary *)jCSD
{
    self.CaseSearchDataJSon = jCSD;
    self.planData = [[NSMutableDictionary alloc] init];
    self.planData[CSD_PLN_NR] = self.CaseSearchDataJSon[CSD_PLN_NR];
    self.planData[CSD_PHD_NM] = self.CaseSearchDataJSon[CSD_PHD_NM];
    self.planData[CSD_SITUS_ST] = self.CaseSearchDataJSon[CSD_SITUS_ST];
    self.planData[CSD_RGO_NM] = self.CaseSearchDataJSon[CSD_RGO_NM];
    self.planData[CSD_SALES_REP_NM] = self.CaseSearchDataJSon[CSD_SALES_REP_NM];
    self.planData[CSD_SSA] = self.CaseSearchDataJSon[CSD_SSA];
    self.planData[CSD_PROC_TEAM_NM] = self.CaseSearchDataJSon[CSD_PROC_TEAM_NM];
    self.planData[CSD_TOTAL_ELIG_LVS_CT] = self.CaseSearchDataJSon[CSD_TOTAL_ELIG_LVS_CT];
    
    self.processesData = [[NSMutableArray alloc] init];
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    row[CSD_CASE_NR] = self.CaseSearchDataJSon[CSD_CASE_NR];
    row[CSD_PROC_TYPE_DESC] = self.CaseSearchDataJSon[CSD_PROC_TYPE_DESC];
    row[CSD_OWNR_NM] = self.CaseSearchDataJSon[CSD_OWNR_NM];
    row[CSD_CASE_STATUS_DESC] = self.CaseSearchDataJSon[CSD_CASE_STATUS_DESC];
    row[CSD_CASE_START_DT] = self.CaseSearchDataJSon[CSD_CASE_START_DT];
    row[CSD_TERM_DT] = self.CaseSearchDataJSon[CSD_TERM_DT];
    self.processesData[0] = row;
}

- (IBAction)home:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section) {
        case 0:
        {
            return [self.planData count];
            break;
        }
        case 1:
        {
            return 1;
            break;
        }
        case 2:
        {
            return [self.processesData count];
            break;
        }
            default:
        {
            return 0;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    
    switch(section) {
        case 0:
        {
            sectionTitle = @"";
            break;
        }
        case 1:
        {
            sectionTitle = @"Process";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    switch(indexPath.section) {
        case 0:
        {
            CellIdentifier = @"PlanData";
            MD1PlanCell *cell = (MD1PlanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.keyLabel.text = self.planTitleOrder[indexPath.row];
            cell.valueLabel.text = self.planData[self.planInfoOrder[indexPath.row]];
            return cell;
            break;
        }
        case 1:
        {
            CellIdentifier = @"ProcessesHeader";
            MD1ProcessesCell *cell = (MD1ProcessesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.typeLabel.text = @"Process";
            cell.statusLabel.text = @"Status";
            return cell;
            
            break;
        }
        case 2:
        {
            CellIdentifier = @"ProcessesData";
            MD1ProcessesCell *cell = (MD1ProcessesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            NSMutableDictionary *row = self.processesData[indexPath.row];
            cell.typeLabel.text = row[CSD_PROC_TYPE_DESC];
            cell.statusLabel.text = row[CSD_CASE_STATUS_DESC];
            return cell;
            
            break;
        }
        default:
        {
            return nil;
        }
    }
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MD1PlanCell *cell = sender;
    UITableView *table = (UITableView *)cell.superview.superview;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    NSDictionary *row = self.processesData[indexPath.row];
    
    MD1ProcessViewController *targetvc =[segue destinationViewController];
    [targetvc segueData:row];
    
}




@end
