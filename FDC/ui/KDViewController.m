//
//  KDViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 02/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"
#import "KDBarButton.h"

#define RECT_VIEW       CGRectMake(ZERO, ZERO, WINDOW_WIDTH, WINDOW_HEIGHT+14)
#define LOAD_RECT_HIDE  CGRectMake(ZERO, -30, WINDOW_WIDTH, 30)
#define LOAD_RECT_SHOW  CGRectMake(ZERO, ZERO, WINDOW_WIDTH, 30)

@interface KDViewController ()
- (void) setConfigurations;
@end

@implementation KDViewController
{
    FRTools *tools;
}

@synthesize dictionary;
@synthesize array;
@synthesize edge, waitView, waitLabel, tinyLoadView;
@synthesize controlTextField, controlTextView;

#pragma mark -
#pragma mark Init Methods

- (id) initWithNibName:(NSString*) nibName andDictionary:(NSDictionary*) dict
{
    self = [super initWithNibName:nibName bundle:nil];
    dictionary  = dict;
    return self;
}
- (id) initWithNibName:(NSString*) nibName andArray:(NSArray*) arr
{
    self = [super initWithNibName:nibName bundle:nil];
    array       = arr;
    return self;
}
- (id) initWithNibName:(NSString*) nibName andArray:(NSArray*) arr andDictionary:(NSDictionary*) dict
{
    self = [super initWithNibName:nibName bundle:nil];
    array       = arr;
    dictionary  = dict;
    return self;
}

#pragma mark -
#pragma mark Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfigurations];
}
- (void) viewDidLoadWithBackButton
{
    [super viewDidLoad];
    [self setConfigurations];
    [self setBackButton];
}
- (void) viewDidLoadWithNothing
{
    [super viewDidLoad];
    [self setConfigurations];
    
    [[self navigationItem] setHidesBackButton:YES];
}
- (void) setBackButton
{
    KDBarButton *bt = [[KDBarButton alloc] initWithBack:@selector(pressBackButton:) toTarget:self];
    [[self navigationItem] setLeftBarButtonItem:bt];
    [[self navigationItem] setHidesBackButton:YES];
}
- (void) pressBackButton:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Methods

- (void) setConfigurations
{
    // edge..
    edge                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 64)];
    [edge setBackgroundColor:[UIColor clearColor]];
    
    // navigation bar...
    [[[self navigationController] navigationBar] setBarTintColor:COLOR_DEFAULT];
    [[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    // tab bar...
    [[[self tabBarController] tabBar] setBarTintColor:COLOR_DEFAULT];
    [[[self tabBarController] tabBar] setTintColor:[UIColor whiteColor]];
    [[[self tabBarController] tabBar] setTranslucent:NO];
    
    // load view..
    tinyLoadView = [[UIView alloc] init];
    [tinyLoadView setFrame:LOAD_RECT_HIDE];
    [tinyLoadView setBackgroundColor:COLOR_DEFAULT];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:LOAD_RECT_SHOW];
    [lab setText:@"Buscando atualização..."];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setFont:[UIFont fontWithName:FONT_LIGHT size:16.0]];
    [tinyLoadView addSubview:lab];
    
    // wait view..
    CGRect rect         = CGRectMake(ZERO, -64, WINDOW_WIDTH, WINDOW_HEIGHT);
    waitView            = [[UIView alloc] initWithFrame:rect];
    [waitView setBackgroundColor:COLOR_DEFAULT];
    [waitView setAlpha:0.0];
    
    waitLabel           = [[UILabel alloc] initWithFrame:rect];
    [waitLabel setBackgroundColor:[UIColor clearColor]];
    [waitLabel setAlpha:0.0];
    [waitLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.0]];
    [waitLabel setText:@"Por favor, aguarde."];
    [waitLabel setTextColor:[UIColor whiteColor]];
    [waitLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark -
#pragma mark Methods

- (void) setNewTitle:(NSString*) title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ZERO, ZERO, WINDOW_WIDTH, 30)];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:FONT_LIGHT size:22.0]];
    
    [[self navigationItem] setTitleView:label];
}
- (void) dismissKeyboardWhenTapToScreen
{
    SEL sel = @selector(dismissKeyboard);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    tap.cancelsTouchesInView = NO;
    [[self view] addGestureRecognizer:tap];
}
- (void) dismissKeyboard
{
    if (controlTextView)
        [controlTextView endEditing:YES];
    if (controlTextField)
        [controlTextField endEditing:YES];
}

#pragma mark -
#pragma mark Load Methods

- (void) showWaitView
{
    [self dismissKeyboard];
    [[self view] addSubview:waitView];
    [[self view] addSubview:waitLabel];
    [UIView animateWithDuration:0.2f animations:^{
        [waitView setAlpha:0.85];
        [waitLabel setAlpha:1.0];
    }];
}
- (void) hideWaitView
{
    [UIView animateWithDuration:0.2f animations:^{
        [waitView setAlpha:0.0];
        [waitLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        [waitView removeFromSuperview];
        [waitLabel removeFromSuperview];
    }];
}

- (void) showTinyLoadView
{
    [[self view] addSubview:tinyLoadView];
    [UIView animateWithDuration:0.2f animations:^{
        [tinyLoadView setFrame:LOAD_RECT_SHOW];
    }];
}
- (void) hideTinyLoadView
{
    [UIView animateWithDuration:0.2f animations:^{
        [tinyLoadView setFrame:LOAD_RECT_HIDE];
    } completion:^(BOOL finished) {
        [tinyLoadView removeFromSuperview];
    }];
}

- (BOOL) hasEnteredPINCode
{
    tools = [[FRTools alloc] initWithTools];
    NSDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    
    if ([[logs objectForKey:KEY_PIN_CODE] isEqualToString:KEY_YES])
        return YES;
    else
        return NO;
}

@end
