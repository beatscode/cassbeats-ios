//
//  MyTrack.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/22/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTrack : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic) BOOL selected;
@property(nonatomic,strong) NSString *size;

-(void)toggleSelected;
@end
