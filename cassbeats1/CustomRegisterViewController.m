//
//  CustomRegisterViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 6/29/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "CustomRegisterViewController.h"
#import "AppDelegate.h"
@interface CustomRegisterViewController ()

@end

@implementation CustomRegisterViewController

@synthesize registerWebView;

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
    AppModel *model = [AppModel sharedModel];
    NSArray *user = [model getUserData];
    NSLog(@"%@",user);
    NSURL *url = [self URLByAppendingQueryString:[NSString stringWithFormat:@"%@requestdropbox",[model getServerBase]]:[NSString stringWithFormat:@"user_id=%@", [user valueForKey:@"id"]]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",url);
    [registerWebView loadRequest:requestObj];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector( confirmDropBoxAuth )];
    
    self.navigationItem.rightBarButtonItem = doneBtn;
    //self.navigationItem.hidesBackButton = YES;
    self.title = @"Register";
}
- (NSURL *)URLByAppendingQueryString:(NSString *)query:(NSString *)queryString {
    AppModel *model = [AppModel sharedModel];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [NSString stringWithFormat:@"%@requestdropbox",[model getServerBase]],@"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];

    return theURL;
}

- (void)viewDidUnload
{
    [self setRegisterWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma NDSURLConnection
NSMutableData *receivedData;
-(void)confirmDropBoxAuth{
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    receivedData = [[NSMutableData alloc] init];
    
    AppModel *model = [AppModel sharedModel];
    User *user = model.user;
    
    NSString *params;   
    
    params = [[NSString alloc] initWithFormat:@"user_id=%@",user.server_id];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@confirmDropBoxOAuthURL",[model getServerBase]]];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(connection){
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
    [self confirmedDropBoxRepsonse:receivedData];
}

// Make sure the user has registerred with dropbox and 
-(void)confirmedDropBoxRepsonse:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"%@",userArray);
    if(!error){
        NSArray *errorArray = [json objectForKey:@"error"];
        if(errorArray){
            //Show Popup stating error authenticating
            //[self.statusLabel setText:(NSString *)errorArray];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:@"Your dropbox registration has not been completed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You now are registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            
            SelectTrackViewController *STVC = [[SelectTrackViewController alloc] init];
            [STVC refreshTrackList];
            
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate window].rootViewController = appDelegate.tabBarController;            
            
        }
    }
}

@end
