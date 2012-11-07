//
//  TrackListeningViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 11/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TrackListeningViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *TrackWebView;
@property (strong, nonatomic) NSString *track_url;
@property (strong, nonatomic) NSDictionary *track;
@end
