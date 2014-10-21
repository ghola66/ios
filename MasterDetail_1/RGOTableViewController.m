//
//  CustomTableViewController.m
//  CustomTable
//
//  Created by Simon on 7/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "RGOTableViewController.h"
#import "RGOTableCell.h"
#import "RGO.h"

@interface RGOTableViewController () <UISearchDisplayDelegate>

@end

@implementation RGOTableViewController
{

    NSArray *searchResults;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.RGOs count];
    }
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    RGOTableCell *cell = (RGOTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RGOTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    RGO *rgo = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        rgo = [searchResults objectAtIndex:indexPath.row];
    } else {
        rgo = [self.RGOs objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = rgo.cd;
    cell.prepTimeLabel.text = rgo.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RGO *rgo = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        rgo = [searchResults objectAtIndex:indexPath.row];
    } else {
        rgo = [self.RGOs objectAtIndex:indexPath.row];
    }
/*
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:rgo.cd
                                 message:@""
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
    // shows alert to user
    [notPermitted show];
 */
    self.RGOselected = rgo;
    [self performSegueWithIdentifier:@"unwindToSearchID" sender:self];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (cd contains[cd] %@)", searchText, searchText];
    searchResults = nil;
    searchResults = [self.RGOs filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
