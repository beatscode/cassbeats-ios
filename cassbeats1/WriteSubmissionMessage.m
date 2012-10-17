//
//  WriteSubmissionMessage.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/28/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "WriteSubmissionMessage.h"

@implementation WriteSubmissionMessage
@synthesize saveMessageBtn;

@synthesize saveButton,messageBody;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveMessage:)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
        self.title = @"Write Message";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_plain"]];
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.saveMessageBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[self class], nil] setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
}

- (void)viewDidUnload
{
    [self setSaveMessageBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.saveButton = nil;
    self.messageBody = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveMessage:(id)sender {
    
    AppModel *model = [AppModel sharedModel];
    model.submissionMessage = self.messageBody.text;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
