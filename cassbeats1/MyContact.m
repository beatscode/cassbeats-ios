//
//  MyContact.m
//  cassbeats1
//
//  Created by Alexander Casanova on 5/18/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "MyContact.h"

@implementation MyContact
@synthesize name = _name;
@synthesize emails = _emails;
@synthesize selected;

-(id)init{
    
    self = [super init];
    if(self){
        self.selected = NO;
        NSLog(@"This Contact is not selected? %d",self.selected);
    }
    return self; 
}


-(void)toggleSelected{
    self.selected = !self.selected;
}

@end
