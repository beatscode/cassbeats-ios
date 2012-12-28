//
//  SubmissionViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/7/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "SubmissionViewController.h"
#import "AppModel.h"

@implementation SubmissionViewController

@synthesize menuData;
@synthesize cvController;
@synthesize vpsController;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.menuData = [NSArray arrayWithObjects:@"Create Submission",@"View Past Submissions",@"Library", nil];
    [self setTitle:@"Options"];

}

-(void)viewDidUnload{
    [self setMenuData:nil];
    [self viewDidUnload];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [menuData objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
  // NSString *selection = [self.menuData objectAtIndex:row];
    
    switch (row) {
        case createsubmission:
           //[self buildTracks];
            self.cvController = [[CreateSubmissionViewController alloc] initWithNibName:@"CreateSubmissionViewController" bundle:nil];
            [self.navigationController pushViewController:self.cvController animated:YES];
            
            break;
        case viewpastsubmissions:
            self.vpsController = [[ViewPastSubmissionsController alloc] initWithNibName:@"ViewPastSubmissionsController" bundle:nil];
            [self.navigationController pushViewController:self.vpsController animated:YES];        
            break;
        case playtrackview:
            //[self buildTracks];
            self.ptController = [[PlayTracksViewController alloc] initWithNibName:@"PlayTracksViewController" bundle:nil];
            [self.navigationController pushViewController:self.ptController animated:YES];
            break;
        default:
            break;
    }
}

@end
