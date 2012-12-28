//
//  TrackListeningViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 11/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "TrackListeningViewController.h"

@interface TrackListeningViewController ()

@end

@implementation TrackListeningViewController

@synthesize TrackWebView;
@synthesize track;
@synthesize track_url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSLog(@"%@",self.track.name);
    self.title = self.track.name;
    
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_plain"]];
    
    NSURL *url = [NSURL URLWithString:self.track_url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.TrackWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
