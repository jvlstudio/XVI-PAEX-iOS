//
//  Speech.m
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Speech.h"
#import "SpeechHead.h"
#import "SpeechFoot.h"
#import "AvalSingle.h"

#import "EventManager.h"

@interface Speech ()
- (void) setInfo;
- (void) populate;
@end

@implementation Speech
{
    FRTools *tools;
    EventManager *manager;
}

@synthesize onlyLectures;
@synthesize scr, pc;

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"Palestras"];
    
    // ..
    tools       = [[FRTools alloc] initWithTools];
    manager     = [[EventManager alloc] init];
    
    // ..
    [self setInfo];
    [self populate];
}

#pragma mark -
#pragma mark Methods

- (void) setInfo
{
    NSArray *agenda = [tools propertyListRead:PLIST_AGENDA];
    onlyLectures = [NSMutableArray array];
    
    for (NSArray *day in agenda)
        for (NSDictionary *lecture in day)
            if (![[lecture objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_BREAK])
                [onlyLectures addObject:lecture];
    
    // ..
    // pc..
    NSInteger currentPage   = 0;
    for (NSDictionary *dict in onlyLectures)
    {
        if ([[dict objectForKey:KEY_SLUG] isEqualToString:[[self dictionary] objectForKey:KEY_SLUG]])
            break;
        
        currentPage++;
    }
    [pc setNumberOfPages:[onlyLectures count]];
    [pc setCurrentPage:currentPage];
    
    // ..
    // scr..
    CGPoint currentOffset   = CGPointMake(WINDOW_WIDTH*currentPage, ZERO);
    [scr setContentSize:CGSizeMake(WINDOW_WIDTH*[onlyLectures count], scr.contentSize.height)];
    [scr setContentOffset:currentOffset];
}
- (void) populate
{
    for (uint f=0; f < [onlyLectures count]; f++)
    {
        CGRect rectScr      = scr.frame;
        NSDictionary *dict  = [onlyLectures objectAtIndex:f];
        NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
        
        UIScrollView *contentScroll = [[UIScrollView alloc] init];
        [contentScroll setFrame:CGRectMake(f*rectScr.size.width, ZERO, rectScr.size.width, rectScr.size.height-59)];
        
        UIView *contentView = [[UIView alloc] init];
        [contentView setBackgroundColor:[UIColor clearColor]];
        
        SpeechHead *head    = (SpeechHead*)[xib objectAtIndex:kCellSpeechHead];
        CGRect rect1        = head.frame;
        [[head labName] setText:[dict objectForKey:KEY_TITLE]];
        [[head labSubname] setText:[dict objectForKey:KEY_SUBTITLE]];
        [[head labSubname] alignTop];
        
        SpeechFoot *foot    = (SpeechFoot*)[xib objectAtIndex:kCellSpeechFoot];
        CGRect rect2        = foot.frame;
        rect2.origin.y      = rect1.size.height;
        [foot setFrame:rect2];
        
        [[foot butAval] setTag:f];
        [[foot butSchedule] setTag:f];
        [[foot butAval] addTarget:self action:@selector(pressAval:) forControlEvents:UIControlEventTouchUpInside];
        [[foot butSchedule] addTarget:self action:@selector(pressSchedule:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect3        = CGRectMake(ZERO, ZERO, WINDOW_WIDTH, rect1.size.height+rect2.size.height);
        [contentView setFrame:rect3];
        [contentScroll setContentSize:CGSizeMake(WINDOW_WIDTH, rect3.size.height)];
        
        [contentView addSubview:head];
        [contentView addSubview:foot];
        [contentScroll addSubview:contentView];
        
        [scr addSubview:contentScroll];
    }
}

#pragma mark -
#pragma mark UIScrolViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scr)
    {
        CGPoint currentOffset   = scrollView.contentOffset;
        float   currentPage     = currentOffset.x/WINDOW_WIDTH;
        [pc setCurrentPage:currentPage];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == scr)
    {
        CGPoint currentOffset   = scrollView.contentOffset;
        float   currentPage     = currentOffset.x/WINDOW_WIDTH;
        [pc setCurrentPage:currentPage];
    }
}

#pragma mark -
#pragma mark IBActions

- (void) pressAval:(id)sender
{
    UIButton *button    = (UIButton*) sender;
    NSInteger index     = [button tag];
    NSDictionary *dict  = [onlyLectures objectAtIndex:index];
    
    AvalSingle *vc = [[AvalSingle alloc] initWithNibName:NIB_AVAL_SINGLE andDictionary:dict];
    [[self navigationController] pushViewController:vc animated:YES];
}
- (void) pressSchedule:(id)sender
{
    UIButton *button    = (UIButton*) sender;
    NSInteger index     = [button tag];
    NSDictionary *dict = [onlyLectures objectAtIndex:index];
    
    [manager saveAtLogs:dict];
}

@end
