//
//  AppDelegate.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize loginController = _loginController;
@synthesize tabBarController= _tabBarController;
@synthesize navController   = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //_loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //[_window rootViewController: _loginController];
    //[_window addSubview:[_loginController view]];
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    _loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [_window.rootViewController presentModalViewController:_loginController animated:YES];
    [self.window makeKeyAndVisible];
    [self customizeAppearance];
    return YES;
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
