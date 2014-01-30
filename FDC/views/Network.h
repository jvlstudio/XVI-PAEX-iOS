//
//  Network.h
//  FDC
//
//  Created by Felipe Ricieri on 09/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"
#import <MessageUI/MessageUI.h>

@interface Network : KDViewController
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate,
MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *originalData;
@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UITextField *tfSearch;

#pragma mark -
#pragma mark IBActions

- (IBAction) doneEditing:(id)sender;

@end
