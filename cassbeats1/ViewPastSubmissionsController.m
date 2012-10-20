//
//  ViewPastSubmissionsController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/28/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "ViewPastSubmissionsController.h"

@implementation ViewPastSubmissionsController

@synthesize submissions;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppModel *model = [AppModel sharedModel];
    self.submissions = [model getAllSubmissions];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.submissions count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *msg = [[NSString alloc] init]; 
    CGSize cellSize;
    CGSize maxSize; 
    msg = @"%d Contact(s),%d Track(s)\nEmails: %@"; 
    maxSize  = CGSizeMake(380.0f, MAXFLOAT);
    cellSize = [msg sizeWithFont:[UIFont systemFontOfSize:13]
               constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    cellSize.height = cellSize.height + 45;
    return cellSize.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    AppModel *model = [AppModel sharedModel];
    NSUInteger row = [indexPath row];
    Submission *submission = [self.submissions objectAtIndex:row];
    NSArray *tracks   = [model getSubmissionTracks:submission];
    NSArray *contacts = [model getSubmissionContacts:submission];
    NSString *contactNames = @"";
    for(Contact *obj in contacts){
        NSLog(@"Name: %@ - email: %@",obj.name,obj.email);
        contactNames = [contactNames stringByAppendingString:obj.email];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"On %@",submission.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Contact(s),%d Track(s)\nEmail(s): %@",contacts.count,tracks.count,contactNames];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

-(NSString *)getFormattedDate:(NSString *)dateStr{
   // NSString *dateStr = @"Tue, 25 May 2010 12:53:58 +0000";

    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSLog(@"%@",[dateFormat stringFromDate:date]);
    return [dateFormat stringFromDate:date];
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
    NSUInteger row = [indexPath row];
    Submission *submission = [self.submissions objectAtIndex:row];
    AppModel *model   = [AppModel sharedModel];
    NSArray *tracks   = [model getSubmissionTracks:submission];
    NSArray *contacts = [model getSubmissionContacts:submission];
    NSArray *msg      = [[NSArray alloc] initWithObjects:submission.message, nil];
    
     SubmissionDetailsViewController *subDetailVC = [[SubmissionDetailsViewController alloc] initWithNibName:@"SubmissionDetailsViewController" bundle:nil];

     subDetailVC.tracks   = tracks;
     subDetailVC.contacts = contacts;
     
     subDetailVC.sectionArray = [[NSMutableArray alloc] init ];
     [subDetailVC.sectionArray addObject:contacts];
     [subDetailVC.sectionArray addObject:tracks];
     [subDetailVC.sectionArray addObject: msg];
    
     subDetailVC.title = submission.date;
    
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:subDetailVC animated:YES];
     
}

@end
