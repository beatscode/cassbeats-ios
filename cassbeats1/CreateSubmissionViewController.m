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
@synthesize downloadLbl;
@synthesize sendBtn;

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
    
    downloadLbl.textColor = [UIColor whiteColor];
    
    [[UIButton appearanceWhenContainedIn:[self class], nil] setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[self class], nil] setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [self.sendBtn setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    
    [self.navigationItem.leftBarButtonItem setTitle:@"Options"];
    self.title = @"New Submission";
}
- (void)viewDidUnload
{
    
    [self setSelectTracksBtn:nil];
    [self setSelectContactsBtn:nil];
    [self setWriteMessageBtn:nil];
    [self setDownloadLbl:nil];
    [self setSendBtn:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveSubmission:(id)sender {
    
    AppModel *model = [AppModel sharedModel];
    //will save to both the device and send
    //urlrequest
    [model saveSubmission];
}
- (IBAction)selectTracks:(id)sender {
    
    AppModel *model = [AppModel sharedModel];
    
    if ([[model selectedTracks] count] == 0) {        
        model.trackData = [model makeTracks];     
    }
    
    SelectTrackViewController *sTVC = [[SelectTrackViewController alloc] initWithNibName:@"SelectTrackViewController" bundle:nil];
    // sTVC.tracks = ([tracks count] == 0) ? [model trackData] : tracks;
    [self.navigationController pushViewController:sTVC animated:YES];
}

- (IBAction)selectContacts:(id)sender {
    
    AppModel *model = [AppModel sharedModel];
    NSLog(@"Number of Tracks : %d",[model.selectedTracks count]);
    NSLog(@"Number of Contacts : %d",[model.selectedContacts count]);
    //make sure there are no contacts 
    if ([model.contacts count] == 0) {
      
        ABAddressBookRef addressBook = ABAddressBookCreate();
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
            }

            MyContact *ct = [[MyContact alloc] init];
            ct.name  = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
            ct.emails = allEmails;
            //ct.selected = YES;
            [cts addObject:ct];
           
            CFRelease(emails);
        }
        CFRelease(addressBook);
        CFRelease(people);   
        
        model.contacts = cts;
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
