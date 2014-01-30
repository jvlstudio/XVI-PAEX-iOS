//
//  Agenda.h
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface Agenda : KDViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UITableView *table;

@property (nonatomic, strong) IBOutlet UIView *segmentView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) IBOutlet UIImageView *imgAlert1;
@property (nonatomic, strong) IBOutlet UIImageView *imgAlert2;
@property (nonatomic, strong) IBOutlet UIImageView *imgAlert3;

@property (nonatomic, strong) IBOutlet UILabel *labAlert1;
@property (nonatomic, strong) IBOutlet UILabel *labAlert2;
@property (nonatomic, strong) IBOutlet UILabel *labAlert3;

#pragma mark -
#pragma mark IBActions

- (IBAction) chooseSegment:(id)sender;

- (void) pressYes:(id) sender;
- (void) pressNo:(id) sender;

@end
