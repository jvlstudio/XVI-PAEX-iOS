//
//  NetworkForm.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "NetworkForm.h"
#import "NetworkThanks.h"

@interface NetworkForm ()

@end

@implementation NetworkForm
{
    CGPoint currentOffset;
    FRTools *tools;
}

@synthesize scr, v;
@synthesize lab1, lab2, lab3;
@synthesize but, radio;
@synthesize tfName, tfEmail, tfSetor, tfSubsetor, tfCompany;

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"Cadastro"];
    
    tools   = [[FRTools alloc] initWithTools];
    
    [lab1 setFont:[UIFont fontWithName:FONT_LIGHT size:19.0]];
    [lab2 setFont:[UIFont fontWithName:FONT_LIGHT size:13.0]];
    [lab3 setFont:[UIFont fontWithName:FONT_LIGHT size:13.0]];
    
    currentOffset = scr.contentOffset;
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBut:(id)sender
{
    if (![tools isValidEmail:[tfEmail text]])
        [tools dialogWithMessage:@"Por favor, insira um e-mail válido."];
    // ...
    else if ([[tfName text] length] < 3)
        [tools dialogWithMessage:@"Por favor, insira seu nome."];
    // ...
    else if (![radio isSelected])
        [tools dialogWithMessage:@"É necessário a ciência dos termos antes de continuar."];
    // ...
    else
    {
        NSString *stringToRequest = [NSString stringWithFormat:@"%@?scope=add", URL_NETWORK_ADD];
        
        stringToRequest = [stringToRequest stringByAppendingFormat:@"&name=%@&company=%@&setor=%@&subsetor=%@&email=%@",
                           [[tfName text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[tfCompany text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[tfSetor text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[tfSubsetor text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[tfEmail text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // ...
        [self showWaitView];
        [tools requestUpdateFrom:stringToRequest success:^{
            // ...
            [self hideWaitView];
            NSString *userId    = [tools upData];
            NSMutableDictionary *logs   = [tools propertyListRead:PLIST_LOGS];
            [logs setObject:userId forKey:KEY_USER_ID];
            [logs setObject:KEY_YES forKey:KEY_PIN_CODE];
            [tools propertyListWrite:logs forFileName:PLIST_LOGS];
            // ...
            NetworkThanks *vc = [[NetworkThanks alloc] initWithNibName:NIB_NETWORK_THANKS bundle:nil];
            [[self navigationController] pushViewController:vc animated:YES];
        } fail:^{
            // ...
            [self hideWaitView];
            //[tools dialogWithMessage:@"Não foi possível completar a requisição. Por favor, verifique sua conexão à internet e tente novamente."];
        }];
    }
}
- (IBAction) pressRadio:(id)sender
{
    if ([radio isSelected])
        [radio setSelected:NO];
    else
        [radio setSelected:YES];
}
- (IBAction) doneEditing:(id)sender
{
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height+KEYBOARD_HEIGHT)];
    [self setControlTextField:textField];
    
    [scr setContentOffset:currentOffset];
}
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height-KEYBOARD_HEIGHT)];
    [textField endEditing:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    currentOffset = scrollView.contentOffset;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentOffset = scrollView.contentOffset;
}

@end
