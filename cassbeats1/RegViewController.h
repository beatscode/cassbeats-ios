//
//  RegViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 6/23/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define registerURL @"http://www.cassbeats.com/mobile/register"
#import "AppModel.h"
#import "CustomRegisterViewController.h"

@interface RegViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *aliasTxtField;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtField;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)registerUser:(id)sender;
- (IBAction)showLogin:(id)sender;

@end
