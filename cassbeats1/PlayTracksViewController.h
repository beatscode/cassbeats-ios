//
//  PlayTracksViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 11/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "MyTrack.h"
#import "TrackListeningViewController.h"
#define pullTrackListeningURL @"http://www.cassbeats.com/mobile/pullTrackListeningURL"

@interface PlayTracksViewController : UITableViewController

@property(nonatomic,strong) NSMutableArray *tracks;
@property(nonatomic,strong) NSMutableArray *filteredTracks;
@property(nonatomic) BOOL isFiltered;
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic) MyTrack *sTrack;
@property(strong,nonatomic) NSDictionary *sTrackData;
@end
