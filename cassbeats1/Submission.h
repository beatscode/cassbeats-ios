//
//  Submission.h
//  cassbeats1
//
//  Created by Alexander Casanova on 6/3/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Track;

@interface Submission : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * download;
@property (nonatomic, retain) NSSet *submissionToContact;
@property (nonatomic, retain) NSSet *submissionToTrack;
@end

@interface Submission (CoreDataGeneratedAccessors)

- (void)addSubmissionToContactObject:(Contact *)value;
- (void)removeSubmissionToContactObject:(Contact *)value;
- (void)addSubmissionToContact:(NSSet *)values;
- (void)removeSubmissionToContact:(NSSet *)values;

- (void)addSubmissionToTrackObject:(Track *)value;
- (void)removeSubmissionToTrackObject:(Track *)value;
- (void)addSubmissionToTrack:(NSSet *)values;
- (void)removeSubmissionToTrack:(NSSet *)values;

@end
