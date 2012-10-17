//
//  SubmissionDetailsViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 6/27/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "Contact.h"
@interface SubmissionDetailsViewController : UITableViewController


@property (nonatomic,strong) NSArray *tracks;
@property (nonatomic,strong) NSArray *contacts;
@property(nonatomic,strong) NSMutableArray *sectionArray;

@end
