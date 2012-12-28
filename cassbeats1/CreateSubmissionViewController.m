//
//  CreateSubmissionViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/11/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "CreateSubmissionViewController.h"

@implementation CreateSubmissionViewController
@synthesize selectTracksBtn;
@synthesize selectContactsBtn;
@synthesize writeMessageBtn;
@synthesize sendBtn;
@synthesize statusLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customizeAppearance];
    
}
-(void)viewWillAppear:(BOOL)animated{
      [self setStatus];
}

-(void)setStatus{
    AppModel *model = [AppModel sharedModel];
    NSLog(@"Number of Tracks : %d",[model.selectedTracks count]);
    NSLog(@"Number of Contacts : %d",[model.selectedContacts count]);
    NSString *status = [NSString stringWithFormat:@"You have selected %d contact(s), %d track(s) ",[model.selectedTracks count],[model .selectedContacts count]];
    if ([model submissionMessage].length > 0) {
        status = [status stringByAppendingString:@"and a message"];
    }else{
         status = [status stringByAppendingString:@"and no message"];
    }
    [statusLbl setText:status];
}
-(void)customizeAppearance{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_plain"]];
    
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orange_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //    
    //    [selectTracksBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    //    [writeMessageBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    //    [selectContactsBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    //    [sendBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    ////[[UILabel appearance] setColor:[UIColor 
    
    
    [[UIButton appearanceWhenContainedIn:[self class], nil] setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[self class], nil] setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [self.sendBtn setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    
   // [self.navigationItem.leftBarButtonItem setTitle:@"Options"];

    
    self.title = @"New Submission";
}
- (void)viewDidUnload
{
    
    [self setSelectTracksBtn:nil];
    [self setSelectContactsBtn:nil];
    [self setWriteMessageBtn:nil];
    [self setSendBtn:nil];
    [self setStatusLbl:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)saveSubmission:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                      message:@"Please allow 2 to 3 minutes for this submission to complete"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Send", nil];
    [message show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Canceled...");
    }else{
        AppModel *model = [AppModel sharedModel];
        //will save to both the device and send
        //urlrequest
        [model saveSubmission];
    }
}


- (IBAction)selectTracks:(id)sender {
        
    SelectTrackViewController *sTVC = [[SelectTrackViewController alloc] initWithNibName:@"SelectTrackViewController" bundle:nil];
    // sTVC.tracks = ([tracks count] == 0) ? [model trackData] : tracks;
    [self.navigationController pushViewController:sTVC animated:YES];
}
- (BOOL)isABAddressBookCreateWithOptionsAvailable
{
    return &ABAddressBookCreateWithOptions != NULL;
}
- (IBAction)selectContacts:(id)sender {
    
    AppModel *model = [AppModel sharedModel];
    NSLog(@"Number of Tracks : %d",[model.selectedTracks count]);
    NSLog(@"Number of Contacts : %d",[model.selectedContacts count]);
    //make sure there are no contacts 
    if ([model.contacts count] == 0) {
      
        if ([self isABAddressBookCreateWithOptionsAvailable])
        {
            CFErrorRef error = nil;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        // display error message here
                    }
                    else if (!granted)
                    {
                        // display access denied error message here
                    }
                    else
                    {
                        // access granted
                        // do the important stuff here
                        
                        //Hold all people in contact
                        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
                        //hold all contacts
                        NSMutableArray *cts = [[NSMutableArray alloc] init ];
                        
                        for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
                            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
                            
                            NSString *firstname = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                            NSString *lastname = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                            if (lastname == nil) {
                                lastname = @"";
                            }
                            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                            NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:ABMultiValueGetCount(emails)];
                            
                            for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
                                
                                NSString* email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                                [allEmails addObject:email];
                                
                                MyContact *ct = [[MyContact alloc] init];
                                ct.name  = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
                                ct.emails = allEmails;
                                [cts addObject:ct];
                            }                        
                            
                            CFRelease(emails);
                        }
                        CFRelease(addressBook);
                        CFRelease(people);
                        
                        model.contacts = cts;

                    }
                });
            });
        } 

    }
    
    SelectContactViewController *sCVC = [[SelectContactViewController alloc] initWithNibName:@"SelectContactViewController" bundle:nil];
    [self.navigationController pushViewController:sCVC animated:YES];
  
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                       property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (IBAction)writeMessage:(id)sender{
    
    WriteSubmissionMessage *wSM = [[WriteSubmissionMessage alloc] initWithNibName:@"WriteSubmissionMessage" bundle:nil];
    [self.navigationController pushViewController:wSM animated:YES];
    
}


- (IBAction)setSubmissionDownloadOption:(UISwitch *)switcher {
    
    AppModel *model = [AppModel sharedModel];
    [model setSubmissionDownloadOption:switcher.on];
}
@end
