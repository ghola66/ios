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
#import "MD1EMailViewController.h"


@interface MD1PlanViewController ()

@property NSMutableArray *planInfoOrder;
@property NSMutableArray *planTitleOrder;
@property NSString *plnNr;
@property NSString *plhm;

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
    self.plnNr = self.CaseSearchDataJSon[CSD_PLN_NR];
    self.plhm = self.CaseSearchDataJSon[CSD_PHD_NM];
    self.title = self.plnNr;
    
    self.planInfoOrder = [[NSMutableArray alloc] init];
    self.planInfoOrder[0] = CSD_IC_NAME;
    self.planInfoOrder[1] = CSD_EFF_DT;
    self.planInfoOrder[2] = CSD_CURRENT_STATUS;
    self.planInfoOrder[3] = CSD_MBO_DT;
    
    self.planTitleOrder = [[NSMutableArray alloc] init];
    self.planTitleOrder[0] = @"Installation Contact:";
    self.planTitleOrder[1] = @"Effective Date:";
    self.planTitleOrder[2] = @"Current Status:";
    self.planTitleOrder[3] = @"Estimated Completion:";
    
    self.planData = [[NSMutableDictionary alloc] init];
    self.planData[CSD_IC_NAME] = self.CaseSearchDataJSon[CSD_IC_NAME];
    self.planData[CSD_EFF_DT] = self.CaseSearchDataJSon[CSD_EFF_DT];
    if(self.CaseSearchDataJSon[CSD_CURRENT_STATUS]){
        self.planData[CSD_CURRENT_STATUS] = self.CaseSearchDataJSon[CSD_CURRENT_STATUS];
    } else {
        self.planData[CSD_CURRENT_STATUS] = @"N/A";
    }
    self.planData[CSD_MBO_DT] = self.CaseSearchDataJSon[CSD_MBO_DT];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) segueData:(NSDictionary *)jCSD
{
    self.CaseSearchDataJSon = jCSD;
}

- (IBAction)home:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
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
            NSArray *statuses = self.CaseSearchDataJSon[@"statuses"];
            
            return [statuses count];
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
            sectionTitle = self.plhm;
            break;
        }
        case 1:
        {
            sectionTitle = @"Activity                   Date Completed";
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
            if(indexPath.row == 0 ) {
                CellIdentifier = @"PlanDataLong";
            }
            MD1PlanCell *cell = (MD1PlanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.keyLabel.text = self.planTitleOrder[indexPath.row];
            cell.valueLabel.text = self.planData[self.planInfoOrder[indexPath.row]];
            
            if(indexPath.row == 0) {
                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:cell.valueLabel.attributedText];
                NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
                [mas addAttributes:underlineAttribute range:(NSRange){0, [cell.valueLabel.attributedText length]}];
                cell.valueLabel.attributedText = mas;
            }
            return cell;
            break;
        }
        case 1:
        {
            UITableViewCell *tcell;
            NSArray *statuses = self.CaseSearchDataJSon[@"statuses"];
            NSDictionary *status = statuses[indexPath.row];
            
            
            NSString *cat = status[@"cat"];
            NSString *desc;
            
            CellIdentifier = @"PlanData";
            if( [cat isEqualToString:@"M"]) {
                CellIdentifier = @"PlanData";
                MD1PlanCell *cell = (MD1PlanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                desc = status[@"desc"];
                cell.valueLabel.text = status[@"st"];
                cell.keyLabel.text = desc;
                tcell = cell;
            } else {
                CellIdentifier = @"ProcessesData";
                
                MD1ProcessesCell *cell = (MD1ProcessesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                
                desc = [NSString stringWithFormat:@"   %@", status[@"desc"]];
                //UIFontDescriptor *fontD = [cell.keyLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
                //cell.keyLabel.font = [UIFont fontWithDescriptor:fontD size:0];
                cell.typeLabel.text = desc;
                tcell = cell;
            }
            
            return tcell;

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
    if ([[segue destinationViewController] isKindOfClass:[MD1EMailViewController class]]){
        MD1EMailViewController *targetvc = [segue destinationViewController];
        targetvc.CaseSearchDataJSon = self.CaseSearchDataJSon;
    }
        else {
    }
}

- (IBAction) unwindToPlan: (UIStoryboardSegue *)segue {
   
}

@end
