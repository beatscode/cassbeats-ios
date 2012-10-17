//
//  RegViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 6/23/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController
@synthesize aliasTxtField;
@synthesize emailTxtField;
@synthesize registerBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customizeAppearance];
    self.emailTxtField.delegate = self;
    self.aliasTxtField.delegate = self;
    
    self.title = @"Register";
}



- (void)viewDidUnload
{
    [self setAliasTxtField:nil];
    [self setEmailTxtField:nil];
    [self setRegisterBtn:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)customizeAppearance{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
     UIImage *orangeButtonImage = [[UIImage imageNamed:@"orange_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    [self.registerBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [self.registerBtn setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    
}
//Register user
- (IBAction)registerUser:(id)sender {
    [self.registerBtn setEnabled:NO];
    [self.registerBtn setTitle:@"Waiting..." forState:UIControlStateNormal];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    receivedData = [[NSMutableData alloc] init];
    
    NSError *error;
    NSMutableString *params = [NSMutableString stringWithString:@""];
    NSMutableDictionary *authData = [NSMutableDictionary dictionary];
    
    [authData setObject:self.aliasTxtField.text forKey:@"alias"];
    [authData setObject:self.emailTxtField.text forKey:@"email"];
    
    [authData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       [params appendFormat:@"%@=%@&",key,obj];
    }];
        
    NSURL *url = [NSURL URLWithString:registerURL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];    
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(error){        
        NSLog(@"connection failed");
    }else{
        NSLog(@"connection succeeded");
    } 

}


#pragma NDSURLConnection
NSMutableData *receivedData;


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
    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    NSLog(@"%@",[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);
    
    // NSLog(@"I received %@",[NSString stringWithFormat:@"%@",receivedData]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = NO;
    [self registrationResponse:receivedData];
}

-(void)registrationResponse:(NSData *)data{
    
    NSError *error = nil;
    UIAlertView *alert;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"%@",json);
    
    if([NSJSONSerialization isValidJSONObject:json] == NO){
        alert = [[UIAlertView alloc] initWithTitle:@"Error Has Occured" message:@"Something Went Wrong Try Again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else{
    

        if(!error){
            NSArray *errorArray = [json objectForKey:@"error"];
           
            if(errorArray){
                 NSLog(@"%@",[errorArray description]);                
                for(NSString *msg in errorArray){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];      
                }

            }else{            
                AppModel *model = [AppModel sharedModel];
                [model updateUserData:[json objectForKey:@"user"]];
                [model updateTrackData:[json objectForKey:@"dropbox_tracks"]];
                
            
                CustomRegisterViewController *CRVC = [[CustomRegisterViewController alloc] initWithNibName:@"CustomRegisterViewController" bundle:nil];
                //id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
                
                // [rootVC dismissModalViewControllerAnimated:NO];
                //[rootVC presentModalViewController:CRVC animated:YES];
                [self.navigationController pushViewController:CRVC animated:YES];
     
            }
        }
    }
    
    [self.registerBtn setEnabled:YES];
    [self.registerBtn setTitle:@"Register" forState:UIControlStateNormal];
}

- (IBAction)showLogin:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    
}

#pragma UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField.tag == 1){
        [self.emailTxtField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

@end
