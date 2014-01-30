//
//  Panelist.h
//  FDC
//
//  Created by Felipe Ricieri on 09/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface Panelist : KDViewController

@property (nonatomic, strong) NSArray *panelists;

@property (nonatomic, strong) IBOutlet UIScrollView *scr;
@property (nonatomic, strong) UIView *v;

@end
