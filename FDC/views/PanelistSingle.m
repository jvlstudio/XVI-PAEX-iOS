//
//  PanelistSingle.m
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "PanelistSingle.h"

#define HEIGHT_VIEW         348
#define HEIGHT_TEXTVIEW     233

@interface PanelistSingle ()

@end

@implementation PanelistSingle

@synthesize scr, v, v2;
@synthesize lab1, lab2, tv;
@synthesize imgPicture;

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"Palestrante"];
    
    [v2 setBackgroundColor:COLOR_DEFAULT];
    
    [lab1 setFont:[UIFont fontWithName:FONT_BOLD size:20.0]];
    [lab2 setFont:[UIFont fontWithName:FONT_LIGHT size:11.0]];
    [tv setFont:[UIFont fontWithName:FONT_LIGHT size:13.0]];
    
    [lab1 setText:[[self dictionary] objectForKey:KEY_NAME]];
    [lab2 setText:[[self dictionary] objectForKey:KEY_TITLE]];
    
    [lab1 alignBottom];
    [lab2 alignTop];
    
    [tv setText:[[self dictionary] objectForKey:KEY_DESCRIPTION]];
    /*CGRect rectTv   = tv.frame;
    NSLog(@"%f", tv.contentSize.height);
    if (HEIGHT_TEXTVIEW < tv.contentSize.height)
    {
        rectTv.size.height  = tv.contentSize.height;
        CGRect rect = v.frame;
        rect.size.height    += (tv.contentSize.height - HEIGHT_TEXTVIEW);
        [v setFrame:rect];
    }
    [tv setFrame:rectTv];*/
    
    NSString *strImg    = [NSString stringWithFormat:@"%@@2x.png", [[self dictionary] objectForKey:KEY_SLUG]];
    NSString *strURL    = [NSString stringWithFormat:@"%@/uploads/large/%@", URL, strImg];
    [imgPicture setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"panelist_noimage.png"]];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

@end
