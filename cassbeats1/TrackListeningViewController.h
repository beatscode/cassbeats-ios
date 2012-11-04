//
//  TrackListeningViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 11/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackListeningViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *TrackWebView;
@property (strong, nonatomic) NSString *track_url;

@end
