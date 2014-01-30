//
//  AvalEvent.m
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AvalEvent.h"
#import "AvalFormPart.h"

#define HEIGHT_CONTENT_HEADER   136

@interface AvalEvent ()
- (void) setInfo;
- (void) populate;
/**/
- (void) setStarsOff;
- (void) setStarOn:(NSInteger) star;
@end

@implementation AvalEvent
{
    FRTools *tools;
}

@synthesize starScore;
@synthesize itemsToAvalKeys, itemsToAvalLabels;
@synthesize scr, v, footView, butOk;
@synthesize butStar1, butStar2, butStar3, butStar4, butStar5;

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    [self setNewTitle:@"Avaliação do Evento"];
    
    tools             = [[FRTools alloc] initWithTools];
    
    itemsToAvalKeys   = [NSArray arrayWithObjects:
                         @"aval_points_weak",
                         @"aval_points_strong",
                         @"aval_comments",
                         @"aval_themes",
                         @"aval_panelists",
                         @"aval_other",
                         nil];
    
    itemsToAvalLabels = [NSArray arrayWithObjects:
                         @"Pontos de melhoria:",
                         @"Pontos positivos:",
                         @"Outros comentários:",
                         @"Temas:",
                         @"Palestrantes:",
                         @"Outras sugestões:",
                         nil];
    // ..
    [self setInfo];
    [self populate];
}

#pragma mark -
#pragma mark Methods

- (void) setInfo
{
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
    
    CGRect rect = footView.frame;
    rect.origin.y   = HEIGHT_CONTENT_HEADER;
    [footView setFrame:rect];
    
    [scr addSubview:footView];
    // ...
    [self dismissKeyboardWhenTapToScreen];
}
- (void) populate
{
    for (uint i=0; i<[itemsToAvalKeys count]; i++)
    {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
        AvalFormPart *part  = (AvalFormPart*)[xib objectAtIndex:kCellAvalFormPart];
        
        [[part labTitle] setFont:[UIFont fontWithName:FONT_LIGHT size:17.0]];
        [[part labTitle] setText:[itemsToAvalLabels objectAtIndex:i]];
        [[part comments] setDelegate:self];
        [[part comments] setTag:i];
        
        CGRect rect1        = part.frame;
        rect1.origin.y      = (i * part.frame.size.height) + HEIGHT_CONTENT_HEADER;
        [part setFrame:rect1];
        
        CGRect rect3        = footView.frame;
        rect3.origin.y      += part.frame.size.height;
        [footView setFrame:rect3];
        
        [scr setContentSize:CGSizeMake(v.frame.size.width, footView.frame.origin.y + footView.frame.size.height)];
        [scr addSubview:part];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressStar1:(id)sender
{
    [self setStarOn:1];
}
- (IBAction) pressStar2:(id)sender
{
    [self setStarOn:2];
}
- (IBAction) pressStar3:(id)sender
{
    [self setStarOn:3];
}
- (IBAction) pressStar4:(id)sender
{
    [self setStarOn:4];
}
- (IBAction) pressStar5:(id)sender
{
    [self setStarOn:5];
}

- (IBAction) pressOk:(id)sender
{
    // ..
    if (starScore > 0)
    {
        NSString *stringToRequest   = [NSString stringWithFormat:@"%@?scope=aval", URL_AVAL_EVENT];
        NSString *params            = @"";
        
        NSArray *subviews = [scr subviews];
        for (UIView *subv in subviews)
        {
            if ([subv isKindOfClass:[AvalFormPart class]])
            {
                AvalFormPart *af    = (AvalFormPart*) subv;
                NSString *avalKey   = [itemsToAvalKeys objectAtIndex:[[af comments] tag]];
                NSString *avalLabel = [itemsToAvalLabels objectAtIndex:[[af comments] tag]];
                NSString *avalValue = [[af comments] text];
                
                NSLog(@"%li. (%@) %@ %@", (long)[[af comments] tag], avalKey, avalLabel, avalValue);
                
                params = [params stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", avalKey, avalValue]];
            }
        }
        
        // get user id
        NSDictionary *logsTemp      = [tools propertyListRead:PLIST_LOGS];
        params = [params stringByAppendingString:[NSString stringWithFormat:@"&user_id=%@&stars=%i", [logsTemp objectForKey:KEY_USER_ID], starScore]];
        
        // ..
        [self showWaitView];
        [tools setPOSTData:params];
        [tools requestUpdateFrom:stringToRequest success:^{
            // ...
            [self hideWaitView];
            //NSLog(@"%@", [tools upData]);
            NSMutableDictionary *logsTemp = [tools propertyListRead:PLIST_LOGS];
            [logsTemp setObject:KEY_YES forKey:KEY_HAS_EVALUATED_EVENT];
            [tools propertyListWrite:logsTemp forFileName:PLIST_LOGS];
            [[self navigationController] popToRootViewControllerAnimated:YES];
        } fail:^{
            [self hideWaitView];
            //[tools dialogWithMessage:@"Não foi possível completar a requisição. Por favor, verifique sua conexão à internet e tente novamente."];
        }];
    }
    // ..
    // no stars, no evaluate
    else [tools dialogWithMessage:@"Por favor, escolha uma nota geral para o evento de 1 a 5, tocando nas estrelas."];
}

#pragma mark -
#pragma mark Methods

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
    starScore = star;
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
    if ([[textView text] isEqualToString:@"..."])
        [textView setText:KEY_EMPTY];
    
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height+KEYBOARD_HEIGHT)];
    [self setControlTextView:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:KEY_EMPTY])
        [textView setText:@"..."];
    
    [scr setContentSize:CGSizeMake(scr.contentSize.width, scr.contentSize.height-KEYBOARD_HEIGHT)];
}

@end
