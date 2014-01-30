//
//  Aval.h
//  FDC
//
//  Created by Felipe Ricieri on 14/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h" 

@interface Aval : KDViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *plist;
@property (nonatomic, strong) NSArray *plistScores;

@property (nonatomic, strong) NSMutableArray *dataLectures;
@property (nonatomic, strong) NSArray *dataOthers;

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UITableView *table;

@property (nonatomic, strong) IBOutlet UIView *segmentView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;

@end
