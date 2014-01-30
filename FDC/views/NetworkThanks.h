//
//  NetworkThanks.h
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface NetworkThanks : KDViewController

@property (nonatomic, strong) NSString *strThanks;

@property (nonatomic, strong) IBOutlet UILabel *lab1;
@property (nonatomic, strong) IBOutlet UIImageView *imgLine;
@property (nonatomic, strong) IBOutlet UIButton *but;

#pragma mark -
#pragma mark Init Methods

- (id) initWithGenericThanks:(NSString*) thanks;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut:(id)sender;

@end
