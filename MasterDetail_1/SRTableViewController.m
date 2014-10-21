//
//  CustomTableViewController.m
//  CustomTable
//
//  Created by Simon on 7/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SRTableViewController.h"
#import "SRTableCell.h"
#import "SalesRep.h"

@interface SRTableViewController () <UISearchDisplayDelegate>

@end

@implementation SRTableViewController
{

    NSArray *searchResults;
    NSArray *sectionTitles;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionTitles = [[self.SalesReps allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        
        return [sectionTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        // Return the number of rows in the section.
        NSString *sectionTitle = [sectionTitles objectAtIndex:section];
        NSArray *reps = [self.SalesReps objectForKey:sectionTitle];
        return [reps count];
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
    static NSString *CellIdentifier = @"SRCustomTableCell";
    SRTableCell *cell = (SRTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SRTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    SalesRep *sr = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        sr = [searchResults objectAtIndex:indexPath.row];
    } else {
        NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
        NSArray *reps = [self.SalesReps objectForKey:sectionTitle];
        sr = [reps objectAtIndex:indexPath.row];
    }
    
    cell.idLabel.text = sr.racfid;
    cell.fnLabel.text = sr.fullNm;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesRep *sr = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        sr = [searchResults objectAtIndex:indexPath.row];
    } else {
        NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
        NSArray *reps = [self.SalesReps objectForKey:sectionTitle];
        sr = [reps objectAtIndex:indexPath.row];
    }
/*
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:sr.racfid
                                 message:@""
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
    // shows alert to user
    [notPermitted show];
*/
    self.SRselected = sr;
    [self performSegueWithIdentifier:@"unwindToSearch2ID" sender:self];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionTitles;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(fullNm contains[cd] %@)", searchText ];
    searchResults = nil;
    
    NSMutableArray *allMatches = [NSMutableArray array];
    for(NSString *key in self.SalesReps) {
        NSArray *array = self.SalesReps[key];
        NSArray *matches = [array filteredArrayUsingPredicate:resultPredicate];
        if([matches count] > 0) {
            [allMatches addObjectsFromArray:matches];
        }
    }
    
    searchResults = allMatches;
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
