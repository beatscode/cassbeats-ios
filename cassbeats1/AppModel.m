//
//  AppModel.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import "AppModel.h"

#define saveServerSubmissionURL @"http://www.cassbeats.com/mobile/createSubmission/"
@implementation AppModel

@synthesize userData = _userData;
@synthesize user = _user;
@synthesize contacts = _contacts;
@synthesize selectedContacts = _selectedContacts;
@synthesize selectedTracks = _selectedTracks;
@synthesize trackData = _trackData;
@synthesize submissionMessage = _submissionMessage;
@synthesize downloadable = _downloadable;
@synthesize submissionSubject = _submissionSubject;

#pragma Singleton
static AppModel *sharedOject = nil;

NSMutableData *receivedData;

-(id)init{
    
    self = [super init];
    if(self){
        self.selectedContacts = [[NSMutableArray alloc] initWithObjects:nil];
        self.selectedTracks   = [[NSMutableArray alloc] initWithObjects:nil];
        self.downloadable     = YES;
        self.trackData        = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return self;    
}

-(NSMutableArray *) getAllSubmissions{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Submission" inManagedObjectContext:context];
    request.entity = entity;
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO selector:nil];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:dateSort, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSMutableArray *submissions = [[context executeFetchRequest:request error:nil] mutableCopy];
    return submissions;
}

-(NSArray *)getSubmissionTracks:(Submission *)submission{
    NSArray *tracks = submission.submissionToTrack.allObjects;
    return tracks;
}
-(NSArray *)getSubmissionContacts:(Submission  *)submission{
    NSArray *contacts = submission.submissionToContact.allObjects;
    return contacts;
}

-(BOOL)getUser{

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    request.entity = entity;
    NSError *error = nil;
    BOOL found = NO;
    User *usr = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if(usr != nil){
        self.user = usr;
        found = YES;
    }else{
        found = NO;
    }
    
    return found;
}
-(NSArray *)getUserData{
    return self.userData;
}

-(void)setSubmissionDownloadOption:(BOOL)option{
    self.downloadable = option;
}

-(NSMutableArray *)makeTracks{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    NSLog(@"Track Data %@", self.trackData);
    if([self.trackData isKindOfClass:[NSArray class]]){
        [self.trackData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MyTrack *track = [[MyTrack alloc] init];
            if([obj isKindOfClass:[MyTrack class]]){
                track = (MyTrack *)obj;
                track.selected = NO;
            }else{
                track.name = [obj objectForKey:@"path"];
                track.size = [obj objectForKey:@"size"];                
            }
            [tracks addObject:track];
        }];
   }
    return tracks;
}

-(BOOL)saveSubmission{
    
    BOOL isValid = YES;
    if([self validateSubmission] == YES){
         //Get Date
        // get the current date
        NSDate *date = [NSDate date];
        // format it
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // convert it to a string
        NSString *dateString = [dateFormat stringFromDate:date];
            
        NSManagedObjectContext *context = [self managedObjectContext];

        Submission *submission = (Submission *)[NSEntityDescription insertNewObjectForEntityForName:@"Submission" inManagedObjectContext:context];
        User *usr  = self.user;
        submission.name = [[NSString alloc] initWithFormat:@"Submission"];
        submission.date = dateString;
        submission.message = self.submissionMessage;
        submission.download = [NSNumber numberWithBool:self.downloadable];
        
        NSMutableString *stringForPost  = [[NSMutableString alloc] init];
              
        //Add Tracks to submission
        if([self.selectedTracks count] > 0){
            int size = 0;
            for(MyTrack *mytrack in self.selectedTracks){
                [stringForPost appendString: [NSString stringWithFormat:@"tracks[]=%@&",  mytrack.name]];
                Track *track = (Track *)[NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:context];
                track.name = mytrack.name;
                track.size = mytrack.size;
                
                [submission addSubmissionToTrackObject:track]; 
                size = size  + [mytrack.size intValue];
               
            } 
            [stringForPost appendString: [NSString stringWithFormat:@"size=%d&", size]];
            submission.size = [NSNumber numberWithInt:size];
        }
        
        
        //Add Contacts to submission
        if([self.selectedContacts count] > 0){
           
            for(MyContact *mycontact in self.selectedContacts){
                    
                [stringForPost appendString:[NSString stringWithFormat:@"contacts[]=%@&names[]=%@&",  [mycontact.emails objectAtIndex:0],mycontact.name]];
               
                Contact *contact = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
                
                contact.name = mycontact.name;
                contact.email = [mycontact.emails objectAtIndex:0];
                [submission addSubmissionToContactObject:contact];
            }
        }
        //Add message to post string
        
        [stringForPost appendString:[NSString stringWithFormat:@"download=%@&message=%@&user_id=%@&subject=%@", [NSNumber numberWithBool:self.downloadable], self.submissionMessage, usr.server_id,self.submissionSubject]];
//        
//        if([mutableFetchResults count] > 0){
//            submission = [mutableFetchResults objectAtIndex:0];
//            NSSet *tracksOfSubmission = submission.submissionToTrack;
//            
//            for(Track *track in tracksOfSubmission.allObjects){
//                Submission *sub = (Submission *)track.trackToSubmission;
//            }
//        }
//     
        
        //Reset Ivars
        if(!isValid){
            [self saveSubmissionOnServer:stringForPost];
            [self saveContext];
            self.submissionMessage = nil;
            self.submissionSubject = nil;
            self.downloadable = NO;
            self.selectedContacts  = [[NSMutableArray alloc] initWithObjects:nil];
            self.selectedTracks    = [[NSMutableArray alloc] initWithObjects:nil];
        }
    }
    //send submission to server
    return isValid;
}

-(void)saveUser:(NSArray *)user{
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    request.entity = entity;
    //Get User ID
    NSString *server_id = [NSString stringWithFormat:@"%@",[user valueForKey:@"id"]];
    User *usr = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if(usr != nil){
         usr.email = [user valueForKey: @"email"];
         usr.server_id = server_id;
    }else{
         User *usr = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
         usr.email = [user valueForKey: @"email"];
         usr.server_id = server_id;
    }

    [self saveContext];
    usr = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    self.user = usr;
}
+(id)sharedModel{
    @synchronized(self){
        if(sharedOject == nil)            
            sharedOject = [[super allocWithZone:NULL] init];
    }
    return sharedOject;    
}


- (void)saveContext {
    NSError *error = nil;
    //if (managedObjectContext != nil) {
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    //}
}

-(void)updateUserData:(NSArray *)array{
    self.userData  = array; 
    [self saveUser:array]; 
}

-(void)updateTrackData:(NSArray *)array{
    NSLog(@"%@",array);
    self.trackData = array;   
}

-(BOOL)validateSubmission{
    
    BOOL isValid = YES;
    
    if([self.submissionSubject length] == 0){
        //Alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty Subject line" message:@"You must add a subject line to this submission" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alertView show];
        isValid = NO;
    }
    
    if([self.submissionMessage length] == 0){
        //Alert 
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty Message" message:@"You must add a message to this submission" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alertView show];        
        isValid = NO;       
    }
    
    if([self.selectedTracks count] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Tracks Selected" message:@"You must Select Tracks Save this submission" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay",nil];
        [alertView show];
        isValid = NO;
    }
    
    if([self.selectedContacts count] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Contacts Selected" message:@"You must Select Contacts to save submission" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay",nil];
        [alertView show];
        isValid =NO;
    }
    
    return isValid;
}

-(void)saveSubmissionOnServer:(NSString *)postString{
        
    NSURL *url = [NSURL URLWithString:saveServerSubmissionURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *requestData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    if (!connection) {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed Connection"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[connectFailMessage show];
    }else{
        

    }
    
}

#pragma mark - NSURLConnection

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return request;    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response: %@",response);
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error receiving response: %@", error);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"An Error has occured"
                          message: @"An error has orrcured"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    NSLog(@"%@",[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);
    
    NSLog(@"I received %@",[NSString stringWithFormat:@"%@",receivedData]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = NO;
    // [self userSetup:receivedData];
}



#pragma mark - search submissions

- (NSMutableArray *)getSubmissionByContact:(NSString *)searchText{
    
    NSMutableArray *submissions = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Contact"
                inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"name contains[c] %@ or email contains[c] %@", searchText,searchText];

    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *contacts = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"Contacts : %u", [contacts count]);
    if (contacts != nil) {
        for (Contact *c in contacts) {
            [submissions addObject:c.contactToSubmission];
        }
    }
    else {
        // Deal with error.
        NSLog(@"Error");
    }
       
  
    return submissions;
}

-(NSMutableArray *)getSubmissionByTrack:(NSString *)searchText{
    
    NSMutableArray *submissions = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Track"
                inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *tracks = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"Tracks : %u", [tracks count]);
    if (tracks != nil) {
        for (Track *t in tracks) {
            [submissions addObject:t.trackToSubmission];
        }
    }
    else {
        // Deal with error.
        NSLog(@"Error");
    }
    return submissions;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];   
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cassbeats.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
