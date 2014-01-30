//
//  Agenda.m
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Agenda.h"
#import "AgendaCell.h"
#import "AgendaBreakCell.h"
#import "AgendaButton.h"
#import "Speech.h"

#import "EventManager.h"

#define BALL_RED        @"agenda_ball_red.png"
#define BALL_BLUE       @"agenda_ball_blue.png"

typedef enum AlertDay : NSInteger
{
    kDay1   = 0,
    kDay2   = 1,
    kDay3   = 2
}
AlertDay;

@interface Agenda ()
- (void) handleContentUpdate;
- (void) loadContentFromURL;
/**/
- (void) alertHideAll;
- (void) alertUpdateValues;
- (void) alertShowWithDay:(AlertDay) day andValue:(NSInteger) value;
- (void) alertChangeBackgroundForDay:(AlertDay) day;
- (NSInteger) alertTotalForDay:(AlertDay) day;
@end

@implementation Agenda
{
    FRTools *tools;
    EventManager *manager;
}

@synthesize table, sections, tableData;
@synthesize segment, segmentView;
@synthesize imgAlert1, imgAlert2, imgAlert3;
@synthesize labAlert1, labAlert2, labAlert3;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Agenda"];
    
    tools       = [[FRTools alloc] initWithTools];
    manager     = [[EventManager alloc] init];
    
    sections    = [tools propertyListRead:PLIST_AGENDA];
    tableData   = [NSArray array];
    
    if ([sections count]>0)
        tableData   = [sections objectAtIndex:0];
    
    [segmentView setHidden:NO];
    [segmentView setBackgroundColor:COLOR_DEFAULT];
    [segment setTintColor:[UIColor whiteColor]];
    [segment setSelectedSegmentIndex:0];
    
    AlertDay day = kDay1;
    [self alertChangeBackgroundForDay:day];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // ...
    [self alertUpdateValues];
    [self handleContentUpdate];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) chooseSegment:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger index = [segmentedControl selectedSegmentIndex];
    
    tableData = [sections objectAtIndex:index];
    [table reloadData];
    
    AlertDay day = index;
    [self alertChangeBackgroundForDay:day];
}

- (void) pressYes:(id) sender
{
    AgendaButton *button    = (AgendaButton*) sender;
    
    [manager saveAtLogs:[button panelist]];
    [self alertUpdateValues];
}
- (void) pressNo:(id) sender
{
    AgendaButton *button    = (AgendaButton*) sender;
    
    [manager removeAtLogs:[button panelist]];
    [self alertUpdateValues];
}

#pragma mark -
#pragma mark Methods

- (void) handleContentUpdate
{
    [tools requestUpdateFrom:URL_AGENDA_VERSION success:^{
        // ...
        NSString *version = [tools upData];
        NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
        if (![[logs objectForKey:LOG_AGENDA_VERSION] isEqualToString:version]
        ||  [sections count] == 0)
        {
            [logs setObject:version forKey:LOG_AGENDA_VERSION];
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
        [tools downloadDataFrom:URL_AGENDA success:^{
            //...
            [self hideTinyLoadView];
            NSDictionary *returnData = [tools JSONData];
            sections    = [returnData objectForKey:KEY_DATA];
            // save..
            [tools propertyListWrite:sections forFileName:PLIST_AGENDA];
            // load..
            tableData   = [sections objectAtIndex:0];
            [table reloadData];
        } fail:^{
            // ..
            [self hideTinyLoadView];
            //[tools dialogWithMessage:@"Não foi possível carregar a nova versão deste conteúdo. Verifique sua conexão à internet para tentar novamente."];
        }];
    });
}

/**/
- (void) alertHideAll
{
    [imgAlert1 setHidden:YES];
    [imgAlert2 setHidden:YES];
    [imgAlert3 setHidden:YES];
    
    [labAlert1 setHidden:YES];
    [labAlert2 setHidden:YES];
    [labAlert3 setHidden:YES];
}
- (void)alertUpdateValues
{
    [self alertHideAll];
    
    NSInteger tot1 = [self alertTotalForDay:kDay1];
    NSInteger tot2 = [self alertTotalForDay:kDay2];
    NSInteger tot3 = [self alertTotalForDay:kDay3];
    
    [self alertShowWithDay:kDay1 andValue:tot1];
    [self alertShowWithDay:kDay2 andValue:tot2];
    [self alertShowWithDay:kDay3 andValue:tot3];
    
    [table reloadData];
}
- (void) alertShowWithDay:(AlertDay) day andValue:(NSInteger) value
{
    switch (day)
    {
        case kDay1:
        {
            if (value > 0) {
                [imgAlert1 setHidden:NO];
                [labAlert1 setHidden:NO];
                NSString *str = [NSString stringWithFormat:@"%li", (long)value];
                [labAlert1 setText:str];
            }
            else {
                [imgAlert1 setHidden:YES];
                [labAlert1 setHidden:YES];
            }
        }
            break;
        case kDay2:
        {
            if (value > 0) {
                [imgAlert2 setHidden:NO];
                [labAlert2 setHidden:NO];
                NSString *str = [NSString stringWithFormat:@"%li", (long)value];
                [labAlert2 setText:str];
            }
            else {
                [imgAlert2 setHidden:YES];
                [labAlert2 setHidden:YES];
            }
        }
            break;
        case kDay3:
        {
            if (value > 0) {
                [imgAlert3 setHidden:NO];
                [labAlert3 setHidden:NO];
                NSString *str = [NSString stringWithFormat:@"%li", (long)value];
                [labAlert3 setText:str];
            }
            else {
                [imgAlert3 setHidden:YES];
                [labAlert3 setHidden:YES];
            }
        }
            break;
    }
}
- (void)alertChangeBackgroundForDay:(AlertDay)day
{
    [imgAlert1 setImage:[UIImage imageNamed:BALL_BLUE]];
    [imgAlert2 setImage:[UIImage imageNamed:BALL_BLUE]];
    [imgAlert3 setImage:[UIImage imageNamed:BALL_BLUE]];
    
    switch (day)
    {
        case kDay1:
        {
            [imgAlert1 setImage:[UIImage imageNamed:BALL_RED]];
        }
            break;
        case kDay2:
        {
            [imgAlert2 setImage:[UIImage imageNamed:BALL_RED]];
        }
            break;
        case kDay3:
        {
            [imgAlert3 setImage:[UIImage imageNamed:BALL_RED]];
        }
            break;
    }
}
- (NSInteger) alertTotalForDay:(AlertDay)day
{
    NSArray *arr = [sections objectAtIndex:day];
    NSInteger total = 0;
    for (NSDictionary *dict in arr)
    {
        if (![[dict objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_BREAK])
            // ...
            if ([manager isPanelistScheduled:[dict objectForKey:KEY_SLUG]])
                total++;
    }
    return total;
}

#pragma mark -
#pragma mark UITable Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell             = nil; //[tableView dequeueReusableCellWithIdentifier:@"agendaCell"];
    
    // break..
    if ([[dict objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_BREAK])
    {
        if (!cell)
            cell    = (AgendaBreakCell*)[xib objectAtIndex:4];
        
        // ...
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_LIGHT size:16]];
        [[cell labSubtitle] setFont:[UIFont fontWithName:FONT_LIGHT size:10]];
        
        [[cell labTitle] setText:[dict objectForKey:KEY_TITLE]];
        
        NSString *strSub    = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:KEY_HOUR_INIT], [dict objectForKey:KEY_HOUR_FINAL]];
        
        if (![[dict objectForKey:KEY_SUBTITLE] isEqualToString:KEY_EMPTY])
            strSub = [strSub stringByAppendingString:[NSString stringWithFormat:@": %@", [dict objectForKey:KEY_SUBTITLE]]];
        
        [[cell labSubtitle] setText:strSub];
        //[[cell labSubtitle] alignTop];
        
        NSString *strImg    = [NSString stringWithFormat:@"break_%@@2x.png", [dict objectForKey:KEY_SLUG]];
        NSString *urlStr    = [NSString stringWithFormat:@"%@/uploads/%@", URL, strImg];
        [[cell imgPicture] setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"agenda_break_noimage.png"]];
    }
    // agenda..
    else
    {
        if (!cell)
            cell    = (AgendaCell*)[xib objectAtIndex:0];
        
        // ...
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_LIGHT size:16]];
        [[cell labSubtitle] setFont:[UIFont fontWithName:FONT_LIGHT size:10]];
        
        [[cell labTitle] setText:[dict objectForKey:KEY_TITLE]];
        
        NSString *strSub    = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:KEY_HOUR_INIT], [dict objectForKey:KEY_HOUR_FINAL]];
        
        if (![[dict objectForKey:KEY_SUBTITLE] isEqualToString:KEY_EMPTY])
            strSub = [strSub stringByAppendingString:[NSString stringWithFormat:@": %@", [dict objectForKey:KEY_SUBTITLE]]];
        
        [[cell labSubtitle] setText:strSub];
        //[[cell labSubtitle] alignTop];
        
        // ..
        AgendaButton *butYes    = (AgendaButton*)[cell butYes];
        AgendaButton *butNo     = (AgendaButton*)[cell butNo];
        
        [butYes setPanelist:dict];
        [butNo setPanelist:dict];
        [butYes addTarget:self action:@selector(pressYes:) forControlEvents:UIControlEventTouchUpInside];
        [butNo addTarget:self action:@selector(pressNo:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([manager isPanelistScheduled:[dict objectForKey:KEY_SLUG]])
        {
            [[cell imgTick] setHidden:NO];
            [[cell imgArrow] setHidden:YES];
            [butYes setEnabled:NO];
            [butYes setAlpha:0.5];
            [butNo setEnabled:YES];
            [butNo setAlpha:1];
        }
        else {
            [[cell imgTick] setHidden:YES];
            [[cell imgArrow] setHidden:YES];
            [butYes setEnabled:YES];
            [butYes setAlpha:1];
            [butNo setEnabled:NO];
            [butNo setAlpha:0.5];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    
    if (![[dict objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_BREAK])
    {
        AgendaCell *cell = (AgendaCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell showOptions];
        /*Speech *vc = [[Speech alloc] initWithNibName:NIB_SPEECH andDictionary:dict];
        [[self navigationController] pushViewController:vc animated:YES];*/
    }
}

@end
