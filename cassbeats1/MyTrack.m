//
//  MyTrack.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/22/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "MyTrack.h"

@implementation MyTrack

@synthesize name,selected,size;

-(id)init{
    self = [super init];
    if(self){
        self.selected = NO;
    }
    return self; 
}

-(void)toggleSelected{
    self.selected = !self.selected;
}

@end
