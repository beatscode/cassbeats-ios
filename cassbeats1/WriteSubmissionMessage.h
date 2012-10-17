//
//  WriteSubmissionMessage.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/28/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

@interface WriteSubmissionMessage : UIViewController


@property (nonatomic,strong) IBOutlet UIButton *saveButton;
@property (nonatomic,strong) IBOutlet UITextView *messageBody;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *saveMessageBtn;

- (IBAction)saveMessage:(id)sender;

@end
