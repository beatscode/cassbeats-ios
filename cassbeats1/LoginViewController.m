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
@synthesize registerBtn;
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
   // [self.emailTextField becomeFirstResponder];
    [self.statusLabel setText:@""];
    
    //Get User if available
    AppModel *model = [AppModel sharedModel]; 
      
    if ([model getUser]) {
       [self.emailTextField setText:[model.user email]];
    }else{
        //For Testing Purposes
        [self.emailTextField setText:@"cassbeats@gmail.com"];
        [self.passwordTextField setText:@"player9"];
    }
    
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orange_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [self.loginBtn setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [self.registerBtn setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setStatusLabel:nil];
    [self setLoginBtn:nil];
    [self setRegisterBtn:nil];
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
    
    NSLog(@"Logging in:%@ %@",emailTextField.text,passwordTextField.text);
    
    // AppModel *model = [AppModel sharedModel];
    [self authenticateUser:emailTextField.text :passwordTextField.text];
    //[model saveUser:emailTextField.text :passwordTextField.text];
    
}
//Register
-(IBAction)registerUser:(id)sender{
    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"Not linked");
        id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
        [[DBSession sharedSession] linkFromController:rootVC ] ;

    }
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
    
    NSError *error;
    NSString *params;
    
    NSMutableDictionary *authData = [NSMutableDictionary dictionary];
    
    [authData setObject:email forKey:@"email"];
    [authData setObject:password forKey:@"password"];
    
    [authData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"%@",obj);
        [params stringByAppendingFormat:@"%@=%@&",key,obj];
    }];
    
    params = [[NSString alloc] initWithFormat:@"email=%@&password=%@",email,password];
    NSLog(@"%@",params);
  
    NSURL *url = [NSURL URLWithString:@"http://localhost/personal/cassbeats2/mobile/mobile/login"];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    if(error){        
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
    
    // NSLog(@"I received %@",[NSString stringWithFormat:@"%@",receivedData]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = NO;
    [self userSetup:receivedData];
}

-(void)userSetup:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"%@",userArray);
    if(!error){
        NSArray *errorArray = [json objectForKey:@"error"];
        NSLog(@"%@",[errorArray description]);
        if(errorArray){
            //Show Popup stating error authenticating
           [self.statusLabel setText:(NSString *)errorArray];
        }else{            
            AppModel *model = [AppModel sharedModel];
            [model updateUserData:[json objectForKey:@"user"]];
            [model updateTrackData:[json objectForKey:@"dropbox_tracks"]];
            
                        
            //Remove Login Screen
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
            
            // Create DBSession for DropBox
            // Find out if user has already registerred with dropbox and cassbeats

        }
    }
}

@end
