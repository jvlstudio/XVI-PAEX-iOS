//
//  Opening.m
//  FDC
//
//  Created by Felipe Ricieri on 16/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "Opening.h"

@interface Opening ()

@end

@implementation Opening
{
    AppDelegate *delegate;
}

#pragma mark -
#pragma mark ViewControllers Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate            = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    imgSponsors         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_sponsors.png"]];
    
    CGRect rectImg      = CGRectMake(ZERO, ZERO, WINDOW_WIDTH, WINDOW_HEIGHT);
    [imgSponsors setFrame:rectImg];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    [imgSponsors setContentMode:UIViewContentModeCenter];
    
    [[self view] addSubview:imgSponsors];
    
    [self animateStart];
}

#pragma mark -
#pragma mark Methods

- (void)animateStart
{
    //..
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animateEnd];
    });
}
- (void) animateEnd
{
    [[delegate window] setRootViewController:[delegate openingWithoutAnimation]];
}

@end
