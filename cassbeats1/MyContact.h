//
//  MyContact.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/18/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyContact : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSMutableArray *emails;
@property(nonatomic,assign) BOOL selected;

-(void)toggleSelected;
@end
