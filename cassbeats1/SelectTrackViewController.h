//
//  SelectTrackViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/22/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "MyTrack.h"
#define refreshTracksURL @"http://localhost/personal/cassbeats4/public/mobile/refreshTracks"

@interface SelectTrackViewController : UITableViewController<UISearchBarDelegate>

@property(nonatomic,strong) NSMutableArray *tracks;
@property(nonatomic,strong) NSMutableArray *filteredTracks;
@property(nonatomic) BOOL isFiltered;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

-(void)refreshTrackList;
-(void)setTracks;
@end
