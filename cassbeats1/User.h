//
//  User.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/3/12.
//  Copyright (c) 2012 Touro College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;

@end
