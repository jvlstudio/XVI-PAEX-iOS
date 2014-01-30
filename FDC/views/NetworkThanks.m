//
//  NetworkThanks.m
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "NetworkThanks.h"

@interface NetworkThanks ()

@end

@implementation NetworkThanks

@synthesize strThanks;
@synthesize lab1, imgLine, but;

#pragma mark -
#pragma mark Init Methods

- (id) initWithGenericThanks:(NSString *)thanks
{
    self = [super initWithNibName:NIB_NETWORK_THANKS bundle:nil];
    strThanks = thanks;
    return self;
}

#pragma mark -
#pragma mark Controller Methods

- (void)viewDidLoad
{
    if(strThanks)
    {
        [super viewDidLoadWithBackButton];
        
        [but setHidden:YES];
        [imgLine setHidden:YES];
        [lab1 setText:strThanks];
    }
    else
        [super viewDidLoadWithNothing];
    
    [self setNewTitle:@"Obrigado!"];
    [[self view] setBackgroundColor:COLOR_DEFAULT];
    
    [lab1 setFont:[UIFont fontWithName:FONT_LIGHT size:17.0]];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self tabBarController] setSelectedIndex:3];
}

@end
