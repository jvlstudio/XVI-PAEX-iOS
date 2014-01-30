//
//  Panelist.m
//  FDC
//
//  Created by Felipe Ricieri on 09/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Panelist.h"
#import "PanelistView.h"

#import "PanelistSingle.h"

#define VIEW_HEIGHT     150

@interface Panelist ()
- (void) handleContentUpdate;
- (void) loadContentFromURL;
- (void) setInfo;
@end

@implementation Panelist
{
    FRTools *tools;
}

@synthesize scr, v;
@synthesize panelists;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Palestrantes"];
    
    // table data..
    tools       = [[FRTools alloc] initWithTools];
    panelists   = [tools propertyListRead:PLIST_PANELISTS];
    v           = [[UIView alloc] initWithFrame:self.view.frame];
    [v setBackgroundColor:[UIColor clearColor]];
    
    if ([panelists count]>0)
        [self setInfo];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // ..
    [self loadContentFromURL];
}

#pragma mark -
#pragma mark Methods

- (void) handleContentUpdate
{
    [tools requestUpdateFrom:URL_PANELISTS_VERSION success:^{
        // ...
        NSString *version = [tools upData];
        NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
        if (![[logs objectForKey:LOG_PANELISTS_VERSION] isEqualToString:version]
        ||  [panelists count] == 0)
        {
            [logs setObject:version forKey:LOG_PANELISTS_VERSION];
            [tools propertyListWrite:logs forFileName:PLIST_LOGS];
            // ..
            [self loadContentFromURL];
        }
    }];
}
- (void) loadContentFromURL
{
    [self showTinyLoadView];
    //..
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // ...
        [tools downloadDataFrom:URL_PANELISTS success:^{
            //...
            [self hideTinyLoadView];
            NSDictionary *returnData = [tools JSONData];
            panelists    = [returnData objectForKey:KEY_DATA];
            // save..
            [tools propertyListWrite:panelists forFileName:PLIST_PANELISTS];
            [self setInfo];
        } fail:^{
            // ..
            [self hideTinyLoadView];
            //[tools dialogWithMessage:@"Não foi possível carregar a nova versão deste conteúdo. Verifique sua conexão à internet para tentar novamente."];
        }];
    });
}
- (void)setInfo
{
    int point   = 0;
    int rows    = 3;
    int col     = 0;
    
    for (NSDictionary *dict in panelists)
    {
        // data..
        NSArray *xib                = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
        PanelistView *panelistView  = (PanelistView*)[xib objectAtIndex:1];
        
        NSString *strImg    = [NSString stringWithFormat:@"%@@2x.png", [dict objectForKey:KEY_SLUG]];
        NSString *strURL    = [NSString stringWithFormat:@"%@/uploads/tiny/%@", URL, strImg];
        [[panelistView imgPicture] setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"panelist_id_picture.png"]];
        [[panelistView labText] setText:[dict objectForKey:KEY_NAME]];
        [[panelistView labText] setFont:[UIFont fontWithName:FONT_LIGHT size:14.0]];
        [[panelistView but] setTag:point];
        [[panelistView but] addTarget:self action:@selector(pressPanelist:) forControlEvents:UIControlEventTouchUpInside];
        
        // check ..
        float row = point%rows;
        if (row < 1 && point > 2)
            col += panelistView.frame.size.height;
        
        // rects ..
        CGRect rectPan       = panelistView.frame;
        rectPan.origin.y    += col;
        rectPan.origin.x     = 10+(rectPan.size.width*row);
        [panelistView setFrame:rectPan];
        
        [v addSubview:panelistView];
        
        point++;
    }
    
    float calc          = round([panelists count]/3);
    float sobr          = [panelists count]%3;
    CGRect rectV        = v.frame;
    //rectV.size.height    = col+75; // +correct..
    // finish.. (correct)
    rectV.size.height   = VIEW_HEIGHT*calc;
    if (sobr > 0)
        rectV.size.height += VIEW_HEIGHT;
    [v setFrame:rectV];
    
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
}

#pragma mark -
#pragma mark IBActions

- (void) pressPanelist:(id)sender
{
    UIButton *but       = (UIButton*) sender;
    NSDictionary *dict  = [panelists objectAtIndex:but.tag];
    PanelistSingle *single  = [[PanelistSingle alloc] initWithNibName:NIB_PANELIST_SINGLE andDictionary:dict];
    [[self navigationController] pushViewController:single animated:YES];
}

@end
