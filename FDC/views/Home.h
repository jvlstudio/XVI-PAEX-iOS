//
//  Home.h
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface Home : KDViewController

@property (nonatomic, strong) IBOutlet UIView *v;
@property (nonatomic, strong) IBOutlet UIScrollView *scr;

@property (nonatomic, strong) IBOutlet UIButton *but1;
@property (nonatomic, strong) IBOutlet UIButton *but2;
@property (nonatomic, strong) IBOutlet UIButton *but3;
@property (nonatomic, strong) IBOutlet UIButton *but4;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut1:(id)sender;
- (IBAction) pressBut2:(id)sender;
- (IBAction) pressBut3:(id)sender;
- (IBAction) pressBut4:(id)sender;

@end
