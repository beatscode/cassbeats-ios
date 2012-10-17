//
//  ViewPastSubmissionsController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/28/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "Submission.h"
#import "SubmissionDetailsViewController.h"

@interface ViewPastSubmissionsController : UITableViewController

@property (nonatomic,strong) NSMutableArray *submissions;

@end
