//
//  SelectContactViewController.h
//  cassbeats1
//
//  Created by Alexander Casanova on 5/14/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "MyContact.h"

@interface SelectContactViewController : UITableViewController

-(void)doneSelectingContacts;
-(void)configureCheckMarkForCell:(UITableViewCell *)cell withSelectedContact:(MyContact *)sContact;
@end
