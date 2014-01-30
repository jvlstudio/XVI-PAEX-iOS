//
//  AvalSingle.h
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface AvalSingle : KDViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic) EvaluateOption evaluateOption;
@property (nonatomic) NSInteger starScore;
@property (nonatomic, strong) NSDictionary *lecture;

@property (nonatomic, strong) IBOutlet UIScrollView *scr;
@property (nonatomic, strong) IBOutlet UIView *v;

@property (nonatomic, strong) IBOutlet UILabel *lab1;
@property (nonatomic, strong) IBOutlet UILabel *lab2;
@property (nonatomic, strong) IBOutlet UILabel *lab3;

@property (nonatomic, strong) IBOutlet UILabel *labTitle;
@property (nonatomic, strong) IBOutlet UILabel *labScore;

@property (nonatomic, strong) IBOutlet UIButton *butStar1;
@property (nonatomic, strong) IBOutlet UIButton *butStar2;
@property (nonatomic, strong) IBOutlet UIButton *butStar3;
@property (nonatomic, strong) IBOutlet UIButton *butStar4;
@property (nonatomic, strong) IBOutlet UIButton *butStar5;
@property (nonatomic, strong) IBOutlet UIButton *butOk;

@property (nonatomic, strong) IBOutlet UITextView *comments;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dict andOption:(EvaluateOption) option;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressStar1:(id)sender;
- (IBAction) pressStar2:(id)sender;
- (IBAction) pressStar3:(id)sender;
- (IBAction) pressStar4:(id)sender;
- (IBAction) pressStar5:(id)sender;
- (IBAction) pressOk:(id)sender;

@end
