//
//  LoginViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)login:(id)sender;
-(void)authenticateUser:(NSString *)email:(NSString *)password;
-(void)userSetup:(NSData *)data;

@end
