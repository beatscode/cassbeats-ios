//
//  CustomRegisterViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 6/29/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *registerWebView;

-(void)confirmedDropBoxRepsonse:(NSData *)data;

@end
