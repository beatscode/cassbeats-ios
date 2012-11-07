//
//  LoginViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController
@synthesize statusLabel;
@synthesize loginBtn;
@synthesize emailTextField;
@synthesize passwordTextField;

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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [self.emailTextField becomeFirstResponder];
    [self.statusLabel setText:@""];
    
    //Get User if available
    AppModel *model = [AppModel sharedModel]; 
      
    if ([model getUser]) {
       User *usr = [model user];
        NSLog(@" email: %@ , id : %@",usr.email, usr.server_id);
        
       [self.emailTextField setText:[model.user email]];
    }
    
    [self customizeAppearance];
    
    self.title = @"Login";
    
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(registerUser)];

    self.navigationItem.leftBarButtonItem = registerBtn;

}
-(void)customizeAppearance{
    //Background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [self.loginBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
}
- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setStatusLabel:nil];
    [self setLoginBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Login 
- (IBAction)login:(id)sender {
    [self authenticateUser:emailTextField.text :passwordTextField.text];    
}
//Register
-(IBAction)registerUser{
    
    RegViewController *RVC = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
    
   // id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
 
   // [[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:YES];
   // [rootVC presentModalViewController:RVC animated:YES];
    
    [self.navigationController pushViewController:RVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(emailTextField.text.length == 0){
        return NO;
    }
    [self login:nil];
    return YES;
}

#pragma NDSURLConnection
NSMutableData *receivedData;
-(void)authenticateUser:(NSString *)email:(NSString *)password{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    receivedData = [[NSMutableData alloc] init];

    NSString *params;
    
    NSMutableDictionary *authData = [NSMutableDictionary dictionary];
    
    [authData setObject:email forKey:@"email"];
    [authData setObject:password forKey:@"password"];
    
    [authData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [params stringByAppendingFormat:@"%@=%@&",key,obj];
    }];
    
    params = [[NSString alloc] initWithFormat:@"email=%@&password=%@",email,password];
  
    NSURL *url = [NSURL URLWithString:loginURL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    if(!connection){
        NSLog(@"connection failed");
    }else{
        NSLog(@"connection succeeded");
    } 
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return request;    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response: %@",response);
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [receivedData appendData:data];
    NSLog(@"Received data is now %d bytes", [receivedData length]); 
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error receiving response: %@", error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"-void)connectionDidFinishLoading:(NSURLConnection*)connection");
    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    NSLog(@"%@",[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = NO;
    [self userSetup:receivedData];
}

-(void)userSetup:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
   // NSLog(@"%@",json);
    if(!error){
        NSArray *errorArray = [json objectForKey:@"error"];
        if(errorArray){
            //Show Popup stating error authenticating
           [self.statusLabel setText:(NSString *)errorArray];
        }else{            
            AppModel *model = [AppModel sharedModel];
            [model updateUserData:[json objectForKey:@"user"]];
            [model updateTrackData:[json objectForKey:@"dropbox_tracks"]];            
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate window].rootViewController = appDelegate.tabBarController;

        }
    }
}

@end
