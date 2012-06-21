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

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)login:(id)sender;
-(void)authenticateUser:(NSString *)email:(NSString *)password;
-(void)userSetup:(NSData *)data;

@end
