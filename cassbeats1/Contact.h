//
//  Contact.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/28/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Submission;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Submission *contactToSubmission;

@end
