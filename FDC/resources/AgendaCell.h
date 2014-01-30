//
//  AgendaCell.h
//  FDC
//
//  Created by Felipe Ricieri on 11/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labTitle;
@property (nonatomic, strong) IBOutlet UILabel *labSubtitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgTick;
@property (nonatomic, strong) IBOutlet UIImageView *imgArrow;

@property (nonatomic, strong) IBOutlet UIView *v;
@property (nonatomic, strong) IBOutlet UIButton *butYes;
@property (nonatomic, strong) IBOutlet UIButton *butNo;

#pragma mark -
#pragma mark Methods

- (void) handlePan:(UIPanGestureRecognizer *)recognizer;
- (void) showOptions;
- (void) hideOptions;

@end
