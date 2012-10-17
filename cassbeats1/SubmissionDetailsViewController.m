//
//  SubmissionDetailsViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 6/27/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "SubmissionDetailsViewController.h"

@interface SubmissionDetailsViewController ()

@end

@implementation SubmissionDetailsViewController

@synthesize tracks = _tracks;
@synthesize contacts = _contacts;
@synthesize sectionArray = _sectionArray;

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
    
    //Create a resend/reload button maybe?
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *msg = [[NSString alloc] init]; 
    CGSize cellSize;
    CGSize maxSize; 
    switch(indexPath.section){
            
        case 2:
            msg = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:0]; 
            maxSize  = CGSizeMake(380.0f, MAXFLOAT);
            cellSize = [msg sizeWithFont:[UIFont systemFontOfSize:13]
                       constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
            cellSize.height = cellSize.height + 45;
        break;
        default:
            cellSize.height = 44;
            
    }
    
 
    return cellSize.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if([[self.sectionArray objectAtIndex:section] count] == 0) return nil;
    NSString *header;
    if(section == 0){
        header = @"Contacts";
    }else if(section == 1){
        header = @"Tracks";
    }else if(section == 2){
        header = @"Message";
    }
    return header;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    NSArray *currentItems = [self.sectionArray objectAtIndex:indexPath.section]; 
    id obj = [currentItems objectAtIndex:row];
    
    if([obj isKindOfClass:[Track class]]){
       
        Track *track = obj;
        
        cell.textLabel.text = track.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Size: %d",track.size];
        
    }else if([obj isKindOfClass:[Contact class]]){
        Contact *contact= obj;
        
        cell.textLabel.text = contact.name;
        cell.detailTextLabel.text =  contact.email;       
    }else if([obj isKindOfClass:[NSString class]]){
        cell.textLabel.text = @"You Wrote...";
        cell.detailTextLabel.text = obj;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
