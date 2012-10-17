//
//  AppModel.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "Submission.h"
#import "Track.h"
#import "Contact.h"
#import "MyContact.h"
#import "MyTrack.h"

@interface AppModel : NSObject<NSURLConnectionDelegate>{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property(nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong,readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong,readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(strong) User *user;
@property(strong) NSArray *userData;
@property(strong) NSArray *trackData;
@property(strong) NSString *submissionMessage;
@property(nonatomic,strong) NSMutableArray *contacts;
@property(nonatomic,strong) NSMutableArray *selectedContacts;
@property(nonatomic,strong) NSMutableArray *selectedTracks;
@property(nonatomic) BOOL downloadable;

+(id)sharedModel;

-(NSURL *)applicationDocumentsDirectory;

-(void)saveContext;
-(void)saveUser:(NSArray *)user;
-(BOOL)getUser;
-(NSArray *)getUserData;
-(void)updateUserData:(NSArray *)array;
-(void)updateTrackData:(NSArray *)array;
-(BOOL)saveSubmission;
-(BOOL)validateSubmission;
-(NSMutableArray *)getAllSubmissions;
-(void)saveSubmissionOnServer:(NSMutableString *)postString;
-(void)setSubmissionDownloadOption:(BOOL)option;
-(void)createDropBoxDBSession;
-(NSArray *)getSubmissionTracks:(Submission *)submission;
-(NSArray *)getSubmissionContacts:(Submission *)submission;
-(NSMutableArray *)makeTracks;
@end
