//
//  Home.m
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Home.h"
#import "HomeContent.h"

@interface Home ()

@end

@implementation Home

@synthesize scr, v;
@synthesize but1, but2, but3, but4;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Home"];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut1:(id)sender
{
    // what it is..
    HomeContent *vc = [[HomeContent alloc] initWithNibName:NIB_HOME_CONTENT bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
}
- (IBAction) pressBut2:(id)sender
{
    // panelist..
    [[self tabBarController] setSelectedIndex:2];
}
- (IBAction) pressBut3:(id)sender
{
    // agenda ...
    [[self tabBarController] setSelectedIndex:1];
}
- (IBAction) pressBut4:(id)sender
{
    // network ..
    [[self tabBarController] setSelectedIndex:3];
}

@end
