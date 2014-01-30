//
//  KDPageControl.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDPageControl.h"

@implementation KDPageControl

@synthesize activeImage, inactiveImage;

- (id)initWithFrame:(CGRect)frame
{
    // if the super init was successfull the overide begins.
    if ((self = [super initWithFrame:frame]))
    {
        // allocate two bakground images, one as the active page and the other as the inactive
        activeImage = [UIImage imageNamed:@"pagecontrol_on.png"];
        inactiveImage = [UIImage imageNamed:@"pagecontrol_off.png"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // if the super init was successfull the overide begins.
    if ((self = [super initWithCoder:aDecoder]))
    {
        // allocate two bakground images, one as the active page and the other as the inactive
        activeImage = [UIImage imageNamed:@"pagecontrol_on.png"];
        inactiveImage = [UIImage imageNamed:@"pagecontrol_off.png"];
    }
    return self;
}

// Update the background images to be placed at the right position
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2, 6)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage)
        {
            if(self.activeImage)
                dot.image = activeImage;
        }
        else
        {
            if (self.inactiveImage)
                dot.image = inactiveImage;
        }
    }
}

// overide the setCurrentPage
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
