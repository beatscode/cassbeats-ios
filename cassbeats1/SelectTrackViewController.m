//
//  SelectTrackViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/22/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "SelectTrackViewController.h"

@implementation SelectTrackViewController

@synthesize tracks;
@synthesize filteredTracks;
@synthesize searchBar;
@synthesize isFiltered;
NSMutableData *receivedData;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTrackList)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = @"Select Tracks";
    [self setTracks];
    self.searchBar.delegate = (id)self;
}

-(void)setTracks{
    if([[AppModel sharedModel] trackData]){
        self.tracks = [[NSMutableArray alloc] initWithArray:[[AppModel sharedModel] trackData]];
    }else{
        self.tracks = [[NSMutableArray alloc] init];
    }
    NSLog(@"Count tracks %@", self.tracks);
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
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

-(void)refreshTrackList{

    AppModel *model = [AppModel sharedModel];
    User *user = [model user];
    [model getUser];
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    receivedData = [[NSMutableData alloc] init];


    NSString *params;

    params = [[NSString alloc] initWithFormat:@"user_id=%@",user.server_id];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@refreshTracks",[model getServerBase]]];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

   NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    if(connection){
        NSLog(@"connection failed");
    }else{
        NSLog(@"connection succeeded");
    }
}


-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response: %@",response);
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [receivedData appendData:data];
    NSLog(@"Received data is now %d bytes", [receivedData length]);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error receiving response: %@", error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"-void)connectionDidFinishLoading:(NSURLConnection*)connection");
    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    NSLog(@"%@",[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);

    // NSLog(@"I received %@",[NSString stringWithFormat:@"%@",receivedData]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = NO;
    [self refreshTracks:receivedData];
}

-(void)refreshTracks:(NSData *)data{

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"%@",userArray);
    if(!error){
        NSArray *errorArray = [json objectForKey:@"error"];
        if(errorArray){
            //Show Popup stating error authenticating
            NSLog(@"%@",errorArray);
        }else{
            AppModel *model = [AppModel sharedModel];
            [model updateTrackData:[json objectForKey:@"dropbox_tracks"]];

            model.trackData = [model makeTracks];
            NSLog(@"Appmodel Track data %@", model.trackData);
            [self setTracks];
            // self.tracks = model.trackData;
            [self.tableView reloadData];
        }
    }
}


#pragma mark - Search Bar
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.isFiltered = FALSE;
    [self.tableView reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if(searchText.length == 0){
        self.isFiltered = FALSE;
    }else{
        self.isFiltered = true;
        self.filteredTracks = [[NSMutableArray alloc] init];

        for(Track* track in self.tracks){
            NSRange nameRange = [track.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [self.filteredTracks addObject:track];
            }
        }
    }

    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section{

    int rowCount;
    if(self.isFiltered){
        rowCount = self.filteredTracks.count;
    }else {
        rowCount = self.tracks.count;
    }

    return rowCount;
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
    MyTrack *track;

    if(self.isFiltered){
        track = [self.filteredTracks objectAtIndex:row];
    }else {
        track = [self.tracks objectAtIndex:row];
    }

    if([model.selectedTracks containsObject:track]){

        MyTrack *sTrack = [model.selectedTracks objectAtIndex:[model.selectedTracks indexOfObject:track]];

        cell.accessoryType = (sTrack.selected == YES) ? UITableViewCellAccessoryCheckmark :UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = track.name;
    cell.detailTextLabel.text = track.size;

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

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    AppModel *model = [AppModel sharedModel];
    MyTrack *track = [self.tracks objectAtIndex:indexPath.row];

    [track toggleSelected];

    if([[model selectedTracks] containsObject:track]){
        [[model selectedTracks] removeObject:track];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        [[model selectedTracks] addObject:track];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

}

@end
