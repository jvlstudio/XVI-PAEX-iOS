//
//  NetworkForm.h
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface NetworkForm : KDViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *v;
@property (nonatomic, strong) IBOutlet UIScrollView *scr;

@property (nonatomic, strong) IBOutlet UILabel *lab1;
@property (nonatomic, strong) IBOutlet UILabel *lab2;
@property (nonatomic, strong) IBOutlet UILabel *lab3;

@property (nonatomic, strong) IBOutlet UIButton *but;
@property (nonatomic, strong) IBOutlet UIButton *radio;

@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfCompany;
@property (nonatomic, strong) IBOutlet UITextField *tfSetor;
@property (nonatomic, strong) IBOutlet UITextField *tfSubsetor;
@property (nonatomic, strong) IBOutlet UITextField *tfEmail;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut:(id)sender;
- (IBAction) pressRadio:(id)sender;
- (IBAction) doneEditing:(id)sender;

@end
