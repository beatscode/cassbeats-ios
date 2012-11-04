//
//  PlayTracksViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 11/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "PlayTracksViewController.h"

@interface PlayTracksViewController ()

@end

@implementation PlayTracksViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     self.title = @"Library";
    [self setTracks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTracks{
    if([[AppModel sharedModel] trackData]){
        NSLog(@"%@",[[AppModel sharedModel] trackData]);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //AppModel *model = [AppModel sharedModel];
    NSUInteger row = [indexPath row];
    MyTrack *track;
    
    if(self.isFiltered){
        track = [self.filteredTracks objectAtIndex:row];
    }else{
        track = [self.tracks objectAtIndex:row];
    }
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [track name];
    
    // Configure the cell...
    // add friend button
//    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    addFriendButton.frame = CGRectMake(200.0f, 5.0f, 75.0f, 30.0f);
//    [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
//    [cell addSubview:addFriendButton];
//    
//    [addFriendButton addTarget:self
//                        action:@selector(playTrack:track *)
//              forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(void)playTrack:(MyTrack *)track{
    NSLog(@"%@",track);
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyTrack *track = [self.tracks objectAtIndex:indexPath.row];
    [self pullTrackToListen:track];
    
}


#pragma mark - Load Track URL

-(void)pullTrackToListen:(MyTrack *)track{
    
    AppModel *model = [AppModel sharedModel];
    User *user = [model user];
    [model getUser];
    NSLog(@"getUser:  %@", [model user]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    receivedData = [[NSMutableData alloc] init];
    
    
    NSString *params;
    
    params = [[NSString alloc] initWithFormat:@"user_id=%@&track=%@",user.server_id,track.name];
    
    NSURL *url = [NSURL URLWithString:pullTrackListeningURL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self loadTrackListenerView:receivedData];
}

-(void)loadTrackListenerView:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"%@",userArray);
    if(!error){
        NSArray *errorArray = [json objectForKey:@"error"];
        if(errorArray){
            //Show Popup stating error authenticating
            NSLog(@"%@",errorArray);
        }else{
            NSString *track_url = [json objectForKey:@"track_url"];
            NSLog(@"%@",track_url);
            // Navigation logic may go here. Create and push another view controller.
            
             TrackListeningViewController *tlViewController = [[TrackListeningViewController alloc] initWithNibName:@"TrackListeningViewController" bundle:nil];
            
            tlViewController.track_url = track_url;
            
             // Pass the selected object to the new view controller.
             [self.navigationController pushViewController:tlViewController animated:YES];
             
        }
    }
}


@end
