//
//  AppDelegate.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
@implementation AppDelegate

@synthesize window = _window;
@synthesize loginController = _loginController;
@synthesize tabBarController= _tabBarController;
@synthesize navController   = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [_window.rootViewController presentModalViewController:_loginController animated:YES];
    //[_window addSubview:[_loginController view]];
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
  
   
    // Set these variables before launching the app
    NSString* appKey = @"wc7pttjxpf2topw";
	NSString* appSecret = @"046i56phg6wtngh";
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps 
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist = 
        [NSPropertyListSerialization 
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:appKey
      appSecret:appSecret
     root:root]; // either kDBRootAppFolder or kDBRootDropbox
  //  dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];	
	//[DBRequest setNetworkRequestDelegate:self];
    
	if (errorMsg != nil) {
		[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		 show];
	}
    

    [self.window makeKeyAndVisible];
    [self customizeAppearance];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}


-(void)customizeAppearance{
    
    //Background
    _loginController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    //Tab Bar
    UIImage *tabBackground = [[UIImage imageNamed:@"tabbar_bg"] 
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    
    UIImage *gradientImage44 = [[UIImage imageNamed:@"navbar2_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
 
    //Navigation
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    
    //Right side nav button
    UIImage *button30 = [[UIImage imageNamed:@"right_nav_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5 )];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //Left Side nav button
    UIImage *buttonBack30 = [[UIImage imageNamed:@"left_nav_button"] 
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30 
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
