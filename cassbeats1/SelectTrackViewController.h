//
//  SelectTrackViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/22/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "MyTrack.h"

@interface SelectTrackViewController : UITableViewController

@property(nonatomic,strong) NSArray *tracks;
-(void)doneSelectingTracks;
@end
