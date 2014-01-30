//
//  NetworkPIN.h
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface NetworkPIN : KDViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSString *theTitle;

@property (nonatomic, strong) IBOutlet UIView *v;
@property (nonatomic, strong) IBOutlet UIScrollView *scr;

@property (nonatomic, strong) IBOutlet UILabel *lab1;
@property (nonatomic, strong) IBOutlet UILabel *lab2;

@property (nonatomic, strong) IBOutlet UIButton *butCancel;
@property (nonatomic, strong) IBOutlet UIButton *butSend;

@property (nonatomic, strong) IBOutlet UITextField *tfPIN;

#pragma mark -
#pragma mark Init Methods

- (id) initWithTitle:(NSString*) string;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressCancel:(id)sender;
- (IBAction) pressSend:(id)sender;
- (IBAction) doneEditing:(id)sender;

@end
