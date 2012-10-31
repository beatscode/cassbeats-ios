//
//  LoginViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "CreateSubmissionViewController.h"
#import "RegViewController.h"
#import "AppDelegate.h"
#define loginURL @"http://www.cassbeats.com/mobile/login"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passwordTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *statusLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *loginBtn;

-(IBAction)login:(id)sender;
-(void)authenticateUser:(NSString *)email:(NSString *)password;
-(void)userSetup:(NSData *)data;
-(IBAction)registerUser;
@end
