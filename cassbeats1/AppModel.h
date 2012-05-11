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

@interface AppModel : NSObject<NSURLConnectionDelegate>{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property(nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong,readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong,readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(strong) NSArray *user;
@property(strong) NSArray *userData;

-(NSURL *)applicationDocumentsDirectory;
-(void)saveContext;
+(id)sharedModel;
-(void)saveUser:(NSString *)email:(NSString *)password;
-(void)addManagedObject;
-(void)getObjectsFromDataStore;
-(void)updateUserData:(NSArray *)array;
@end
