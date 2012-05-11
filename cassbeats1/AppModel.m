//
//  AppModel.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/1/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import "AppModel.h"


@implementation AppModel
//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize managedObjectModel 
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize userData = _userData;
@synthesize user = _user;

#pragma Singleton
static AppModel *sharedOject = nil;

-(id)init{
    
    self = [super init];
    if(self){
        [self getObjectsFromDataStore];
    }
    return self;    
}

-(void)getObjectsFromDataStore{
        //NSLog(@"%@", [self managedObjectModel]);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    request.entity = entity;
    self.user = [[self managedObjectContext] executeFetchRequest:request error:nil];
    //NSLog(@"This should be out user %@",[self.user description]);   
    
}
-(void)addManagedObject{
    
}
-(void)saveUser:(NSString *)email:(NSString *)password{
    User *managedObject = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    
    managedObject.email = email;
    managedObject.password = password;
    [self saveContext];
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
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

-(void)updateUserData:(NSArray *)array{
    self.userData  = array;    
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
