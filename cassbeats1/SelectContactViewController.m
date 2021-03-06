//
//  SelectContactViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/14/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "SelectContactViewController.h"

@implementation SelectContactViewController

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
//    AppModel *model = [AppModel sharedModel];
//    NSLog(@"Amount of selected contacts: %i",[[model selectedContacts] count]);
//
//    for(MyContact *c in [model selectedContacts]){
//        NSLog(@"\n\n");
//        NSLog(@"%@ Is selected %d", c.name, c.selected);
//    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSelectingContacts)];
     self.navigationItem.rightBarButtonItem = rightButton;
    
    self.title = @"Select Contacts";
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

-(void)doneSelectingContacts{
    AppModel *model = [AppModel sharedModel];
    NSLog(@"Just Finished %@",[model selectedContacts]);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    AppModel *model = [AppModel sharedModel];
    return [model.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    AppModel *model = [AppModel sharedModel];
    NSArray *contacts = [model contacts];
    MyContact *obj    = [contacts objectAtIndex:indexPath.row];
    
    if([model.selectedContacts containsObject:obj]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = obj.name;
    cell.detailTextLabel.text = [obj.emails objectAtIndex:0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    AppModel *model = [AppModel sharedModel];
    MyContact *sContact = [[model contacts] objectAtIndex:indexPath.row];
    [sContact toggleSelected];
    [self configureCheckMarkForCell:cell withSelectedContact:sContact];
    
}


-(void)configureCheckMarkForCell:(UITableViewCell *)cell withSelectedContact:(MyContact *)sContact
{
    AppModel *model = [AppModel sharedModel];

    if([[model selectedContacts] containsObject:sContact]){
        [[model selectedContacts] removeObject:sContact];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        sContact.selected = YES;
        [[model selectedContacts] addObject:sContact];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
@end
