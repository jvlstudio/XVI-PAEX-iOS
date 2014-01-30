//
//  AgendaCell.m
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AgendaCell.h"

@implementation AgendaCell
{
    BOOL isOpen;
    CGPoint originalCenter;
}

@synthesize labTitle, labSubtitle;
@synthesize imgTick, imgArrow;
@synthesize v, butNo, butYes;

- (id)init
{
    self = [super init];
    isOpen = NO;
    // add a pan recognizer
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    isOpen = NO;
    // add a pan recognizer
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
    return self;
}

#pragma mark -
#pragma mark horizontal pan gesture methods

-(BOOL) gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y))
        if (translation.x > 0 || (isOpen && translation.x < 0))
            return YES;
    
    return NO;
}

-(void) handlePan:(UIPanGestureRecognizer *)recognizer
{
    // 1
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // if the gesture has just started, record the current centre location
        originalCenter = v.center;
    }
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        if (translation.x > 0 || (isOpen && translation.x < 0))
            v.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
    }
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        // the frame this cell would have had before being dragged
        if (translation.x > 40){
            [self showOptions];
        }else{
            [self hideOptions];
        }
    }
}

- (void) showOptions
{
    isOpen = YES;
    [UIView animateWithDuration:0.3f animations:^{
        v.center = CGPointMake((self.frame.size.width/2)+120, self.frame.size.height/2);
    }];
}
- (void) hideOptions
{
    isOpen = NO;
    [UIView animateWithDuration:0.3f animations:^{
        v.center = CGPointMake((self.frame.size.width/2), self.frame.size.height/2);
    }];
}

@end
