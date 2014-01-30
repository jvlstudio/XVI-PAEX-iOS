//
//  AvalSingle.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AvalSingle.h"

@interface AvalSingle ()
- (void) setInfo;
- (void) setStarsOff;
- (void) setStarOn:(NSInteger) star;
- (BOOL) isEvaluated;
@end

@implementation AvalSingle
{
    FRTools *tools;
}

@synthesize evaluateOption;
@synthesize starScore, lecture;
@synthesize scr, v;
@synthesize lab1, lab2, lab3;
@synthesize labScore, labTitle;
@synthesize butOk, comments;
@synthesize butStar1, butStar2, butStar3, butStar4, butStar5;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dict andOption:(EvaluateOption) option
{
    self = [super initWithNibName:NIB_AVAL_SINGLE andDictionary:dict];
    evaluateOption = option;
    return self;
}

#pragma mark -
#pragma mark Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"Avaliar Palestra"];
    
    tools       = [[FRTools alloc] initWithTools];
    
    // ..
    [self setInfo];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressStar1:(id)sender
{
    if (![self isEvaluated])
        [self setStarOn:1];
}
- (IBAction) pressStar2:(id)sender
{
    if (![self isEvaluated])
        [self setStarOn:2];
}
- (IBAction) pressStar3:(id)sender
{
    if (![self isEvaluated])
        [self setStarOn:3];
}
- (IBAction) pressStar4:(id)sender
{
    if (![self isEvaluated])
        [self setStarOn:4];
}
- (IBAction) pressStar5:(id)sender
{
    if (![self isEvaluated])
        [self setStarOn:5];
}

- (IBAction) pressOk:(id)sender
{
    if (starScore)
    {
        NSMutableDictionary *logs   = [tools propertyListRead:PLIST_LOGS];
        NSLog(@"%@", logs);
        NSString *userId            = [logs objectForKey:KEY_USER_ID];
        NSString *strStars          = [NSString stringWithFormat:@"%li", (long)starScore];
        NSString *stringToRequest   = [NSString stringWithFormat:@"%@?scope=add", URL_LECTURES_EVALUATE];
        
        stringToRequest = [stringToRequest stringByAppendingFormat:@"&evaluate_option=%i&lecture_slug=%@&user_id=%@&score=%@&comments=%@",
                           evaluateOption,
                           [[lecture objectForKey:KEY_SLUG] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [userId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [strStars stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[comments text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // ...
        [self showWaitView];
        [tools requestUpdateFrom:stringToRequest success:^{
            // ...
            [self hideWaitView];
            NSString *logKey = [NSString stringWithFormat:@"%@_%@", KEY_LECTURE_EVALUATED, [lecture objectForKey:KEY_SLUG]];
            [logs setObject:strStars forKey:logKey];
            [tools propertyListWrite:logs forFileName:PLIST_LOGS];
            // ...
            [[self navigationController] popViewControllerAnimated:YES];
        } fail:^{
            // ..
            [self hideWaitView];
            //[tools dialogWithMessage:@"Não foi possível completar a requisição. Por favor, verifique sua conexão à internet e tente novamente."];
        }];
    }
    else {
        //[tools dialogWithMessage:@"Antes de salvar, avalie a palestra tocando nas estrelas."];
    }
}

#pragma mark -
#pragma mark Methods

- (void)setInfo
{
    starScore   = 0;
    lecture     = [self dictionary];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
    
    [lab1 setFont:[UIFont fontWithName:FONT_LIGHT size:14]];
    [lab2 setFont:[UIFont fontWithName:FONT_LIGHT size:12]];
    [lab3 setFont:[UIFont fontWithName:FONT_LIGHT size:13]];
    [labTitle setFont:[UIFont fontWithName:FONT_LIGHT size:21.0]];
    [labScore setFont:[UIFont fontWithName:FONT_LIGHT size:20.0]];
    
    if (evaluateOption == kOptionLectures)
        [labTitle setText:@"O que você achou desta palestra?"];
    else
    {
        NSString *str = [NSString stringWithFormat:@"Deixe sua opinião sobre \"%@\"", [lecture objectForKey:KEY_LABEL]];
        [labTitle setText:str];
    }
    
    // check if already evaluate
    NSDictionary *logs  = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", KEY_LECTURE_EVALUATED, [lecture objectForKey:KEY_SLUG]];
    NSString *evaluate  = [logs objectForKey:logKey];
    if (evaluate)
    {
        NSInteger evalStar  = [evaluate intValue];
        [self setStarOn:evalStar];
        [labScore setText:evaluate];
        [butOk setHidden:YES];
        [comments setHidden:YES];
        [lab3 setHidden:YES];
        [lab2 setText:@"Sua nota"];
        [lab1 setText:@"Obrigado por avaliar esta palestra."];
        [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height-150)];
    }
    
    // ...
    [self dismissKeyboardWhenTapToScreen];
}
- (void) setStarsOff
{
    [butStar1 setSelected:NO];
    [butStar2 setSelected:NO];
    [butStar3 setSelected:NO];
    [butStar4 setSelected:NO];
    [butStar5 setSelected:NO];
}
- (void) setStarOn:(NSInteger) star
{
    [self setStarsOff];
    NSArray *stars = [NSArray arrayWithObjects:butStar1, butStar2, butStar3, butStar4, butStar5, nil];
    for (uint s=0; s<star; s++)
    {
        UIButton *bt = (UIButton*)[stars objectAtIndex:s];
        [bt setSelected:YES];
    }
    [labScore setText:[NSString stringWithFormat:@"%li", (long)star]];
    starScore = star;
}
- (BOOL)isEvaluated
{
    // check if already evaluate
    NSDictionary *logs  = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", KEY_LECTURE_EVALUATED, [lecture objectForKey:KEY_SLUG]];
    NSString *evaluate  = [logs objectForKey:logKey];
    if (evaluate)
        return YES;
    else
        return NO;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

#pragma mark -
#pragma mark UITextViewDelegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@"Comentários"])
        [textView setText:KEY_EMPTY];
    
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height+KEYBOARD_HEIGHT)];
    [self setControlTextView:comments];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:KEY_EMPTY])
        [textView setText:@"Comentários"];
    
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height-KEYBOARD_HEIGHT)];
}

@end
