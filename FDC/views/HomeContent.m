//
//  HomeContent.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "HomeContent.h"
#import "KDBarButton.h"

@interface HomeContent ()

@end

@implementation HomeContent

@synthesize scr, v;

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"O que é"];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

@end
