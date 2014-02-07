//
//  MD1PlansViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/31/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1CaseSearchData.h"
#import "MD1PlansCell.h"
#import "MD1PlansViewController.h"
#import "MD1PlanViewController.h"

@interface MD1PlansViewController ()

- (IBAction)home:(id)sender;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    long retval;
    if(section == 0 ) {
        retval = 1;
    } else {
        retval = [self.resultset count];
    }
    return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if(indexPath.section == 0 ) {
        cellIdentifier = @"PlansHeader";
    } else {
        cellIdentifier = @"PlansData";
    }
    
    MD1PlansCell *cell = (MD1PlansCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.section == 0 ) {
        cell.numberLabel.text = @"Plan #";
        cell.phNameLabel.text = @"Planholder Name";
    } else {
        NSDictionary  *row = self.resultset[indexPath.row];
        
        NSDictionary *jCSD = row[CSD_JSON];
        NSString *plnNr = (NSString *)jCSD[CSD_PLN_NR];
        NSString *phName = (NSString *)jCSD[CSD_PHD_NM];
        
        cell.numberLabel.text = plnNr;
        cell.phNameLabel.text = phName;
    }
    
    return cell;
}

- (IBAction)home:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowPlan"]) {
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MD1PlansCell *cell = sender;
    UITableView *table = (UITableView *)cell.superview.superview;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    NSDictionary  *row = self.resultset[indexPath.row];
    
    NSDictionary *jCSD = row[CSD_JSON];
    MD1PlanViewController *targetvc =[segue destinationViewController];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
