//
//  Speech.h
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"
#import "KDPageControl.h"

@interface Speech : KDViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *onlyLectures;

@property (nonatomic, strong) IBOutlet UIScrollView *scr;
@property (nonatomic, strong) IBOutlet UIPageControl *pc;

#pragma mark -
#pragma mark IBActions

- (void) pressAval:(id)sender;
- (void) pressSchedule:(id)sender;

@end
