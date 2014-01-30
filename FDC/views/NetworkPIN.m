//
//  NetworkPIN.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "NetworkPIN.h"
#import "NetworkForm.h"

@interface NetworkPIN ()
- (void) setInfo;
@end

@implementation NetworkPIN
{
    FRTools *tools;
}

@synthesize theTitle;
@synthesize scr, v;
@synthesize lab1, lab2;
@synthesize butSend, butCancel;
@synthesize tfPIN;

#pragma mark -
#pragma mark Init Methods

- (id) initWithTitle:(NSString*) string
{
    self = [super initWithNibName:NIB_NETWORK_PIN bundle:nil];
    theTitle    = string;
    return self;
}

#pragma mark -
#pragma mark Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Confirmar PIN"];
    
    tools   = [[FRTools alloc] initWithTools];
    
    if (theTitle)
        [lab1 setText:theTitle];
    
    // ..
    [self setInfo];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressCancel:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UITabBarController *presentingController = (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [presentingController setSelectedIndex:0];
}
- (IBAction) pressSend:(id)sender
{
    [self showWaitView];
    [tools requestUpdateFrom:URL_NETWORK_PIN success:^{
        // ...
        [self hideWaitView];
        NSString *pinCode = [tools upData];
        if ([pinCode isEqualToString:[tfPIN text]])
        {
            NetworkForm *vc = [[NetworkForm alloc] initWithNibName:NIB_NETWORK_FORM bundle:nil];
            [[self navigationController] pushViewController:vc animated:YES];
        }
        else {
            [tools dialogWithMessage:@"Este código não está correto. Por favor, tente novamente."];
        }
    } fail:^{
        // ...
        [self hideWaitView];
    }];
}
- (IBAction) doneEditing:(id)sender
{
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark Methods

- (void) setInfo
{
    [lab1 setFont:[UIFont fontWithName:FONT_LIGHT size:18]];
    [lab2 setFont:[UIFont fontWithName:FONT_LIGHT size:14]];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height+KEYBOARD_HEIGHT)];
    [self setControlTextField:textField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height-KEYBOARD_HEIGHT)];
    [textField endEditing:YES];
}

@end
