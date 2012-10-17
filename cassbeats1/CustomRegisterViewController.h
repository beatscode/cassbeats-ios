//
//  CustomRegisterViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 6/29/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define registerViewURL @"http://localhost/personal/cassbeats4/public/mobile/requestdropbox/"
#define confirmDropBoxOAuthURL @"http://localhost/personal/cassbeats4/public/mobile/confirmDropBoxOAuthURL"

@interface CustomRegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *registerWebView;

-(void)confirmedDropBoxRepsonse:(NSData *)data;

@end
