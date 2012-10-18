//
//  TutorialViewController.m
//  cassbeats1
//
//  Created by Alexander Casanova on 10/18/12.
//  Copyright (c) 2012 CassBeats LLC. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customizeAppearance];
}

-(void)customizeAppearance{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

//    UIImage *orangeButtonImage = [[UIImage imageNamed:@"orange_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //UIImage *blueButtonImage = [[UIImage imageNamed:@"blue_button"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
//    
//    [self.registerBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    
//    [self.registerBtn setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
