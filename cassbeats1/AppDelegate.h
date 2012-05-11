//
//  AppDelegate.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong) LoginViewController *loginController;
@property (nonatomic,strong) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,strong) IBOutlet UINavigationController *navController;
@end
