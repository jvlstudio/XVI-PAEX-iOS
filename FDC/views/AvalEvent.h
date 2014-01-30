//
//  AvalEvent.h
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface AvalEvent : KDViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic) NSInteger starScore;

@property (nonatomic, strong) NSArray *itemsToAvalKeys;
@property (nonatomic, strong) NSArray *itemsToAvalLabels;

@property (nonatomic, strong) IBOutlet UIScrollView *scr;
@property (nonatomic, strong) IBOutlet UIView *v;
@property (nonatomic, strong) IBOutlet UIView *footView;

@property (nonatomic, strong) IBOutlet UIButton *butStar1;
@property (nonatomic, strong) IBOutlet UIButton *butStar2;
@property (nonatomic, strong) IBOutlet UIButton *butStar3;
@property (nonatomic, strong) IBOutlet UIButton *butStar4;
@property (nonatomic, strong) IBOutlet UIButton *butStar5;
@property (nonatomic, strong) IBOutlet UIButton *butOk;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressStar1:(id)sender;
- (IBAction) pressStar2:(id)sender;
- (IBAction) pressStar3:(id)sender;
- (IBAction) pressStar4:(id)sender;
- (IBAction) pressStar5:(id)sender;
- (IBAction) pressOk:(id)sender;

@end
