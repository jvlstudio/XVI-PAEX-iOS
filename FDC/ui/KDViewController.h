//
//  KDViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 02/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) UIView *edge;
@property (nonatomic, strong) UIView *waitView;
@property (nonatomic, strong) UILabel *waitLabel;
@property (nonatomic, strong) UIView *tinyLoadView;
@property (nonatomic, strong) UITextView *controlTextView;
@property (nonatomic, strong) UITextField *controlTextField;

#pragma mark -
#pragma mark Init Methods

- (id) initWithNibName:(NSString*) nibName andDictionary:(NSDictionary*) dict;
- (id) initWithNibName:(NSString*) nibName andArray:(NSArray*) arr;
- (id) initWithNibName:(NSString*) nibName andArray:(NSArray*) arr andDictionary:(NSDictionary*) dict;

#pragma mark -
#pragma mark Controller Methods

- (void) viewDidLoadWithBackButton;
- (void) viewDidLoadWithNothing;
- (void) setBackButton;
- (void) pressBackButton:(id)sender;

#pragma mark -
#pragma mark Methods

- (void) setNewTitle:(NSString*) title;
- (void) dismissKeyboardWhenTapToScreen;
- (void) dismissKeyboard;

#pragma mark -
#pragma mark Load Methods

- (void) showWaitView;
- (void) hideWaitView;
- (void) showTinyLoadView;
- (void) hideTinyLoadView;

- (BOOL) hasEnteredPINCode;

@end
