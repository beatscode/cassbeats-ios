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

//@synthesize TrackWebView;
@synthesize player = _player;
@synthesize mpView = _mpView;
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
//    
//    NSString* resourcePath = self.track_url; //your url
//    NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resourcePath]];
//    NSError *error;
//    
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
//    self.audioPlayer.numberOfLoops = 0;
//    self.audioPlayer.volume = 1.0f;
//    [self.audioPlayer prepareToPlay];
//    
//    if (self.audioPlayer == nil)
//        NSLog(@"%@", [error description]);
//    else
//        [self.audioPlayer play];
//    
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString: self.track_url]];
    [self.player prepareToPlay];
    [self.player.view setFrame: self.mpView.bounds];  // player's frame must match parent's
    [self.mpView addSubview: self.player.view];
    // ...
    [self.player play];
    
    
    NSLog(@"%@",self.track);
    self.title = [self.track objectForKey:@"path"];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_plain"]];
//    
//    NSURL *url = [NSURL URLWithString:self.track_url];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [self.TrackWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
