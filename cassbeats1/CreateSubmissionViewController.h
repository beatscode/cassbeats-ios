//
//  CreateSubmissionViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/11/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SelectContactViewController.h"
#import "SelectTrackViewController.h"
#import "WriteSubmissionMessage.h"
#import "AppModel.h"
#import "MyContact.h"
#import "MyTrack.h"

@interface CreateSubmissionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *selectTracksBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectContactsBtn;
@property (weak, nonatomic) IBOutlet UIButton *writeMessageBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadLbl;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)saveSubmission:(id)sender;
- (IBAction)selectTracks:(id)sender;
- (IBAction)selectContacts:(id)sender;
- (IBAction)writeMessage:(id)sender;
- (IBAction)setSubmissionDownloadOption:(UISwitch *)switcher;

@end
