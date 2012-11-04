//
//  SubmissionViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/7/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateSubmissionViewController.h"
#import "ViewPastSubmissionsController.h"
#import "PlayTracksViewController.h"
#import "TutorialViewController.h"

#define createsubmission 0
#define viewpastsubmissions 1
#define playtrackview 2
#define tutorial 3
@interface SubmissionViewController : UITableViewController

@property (nonatomic,strong) CreateSubmissionViewController *cvController;
@property (nonatomic,strong) ViewPastSubmissionsController *vpsController;
@property (nonatomic,strong) TutorialViewController *tvController;
@property (nonatomic,strong) PlayTracksViewController *ptController;
@property(nonatomic,strong)NSArray *menuData;


@end
