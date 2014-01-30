//
//  Aval.m
//  FDC
//
//  Created by Felipe Ricieri on 14/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Aval.h"
#import "AvalCell.h"
#import "AvalStructCell.h"
#import "AvalSingle.h"
#import "AvalEvent.h"

#import "NetworkPIN.h"
#import "NetworkThanks.h"

@interface Aval ()
- (void) setInfo;
- (void) setScores;
- (void) handleContentUpdate;
- (void) loadContentFromURL;
- (NSString*) scoreForSlug:(NSString*) slug;
/**/
- (BOOL) isLectureEvaluated:(NSString*) slug;
/**/
- (void) setTableToLectures;
- (void) setTableToStructure;
@end

@implementation Aval
{
    FRTools *tools;
    NSDictionary *primaryLogs;
}

@synthesize plist, plistScores;
@synthesize dataLectures, dataOthers;
@synthesize table, tableData;
@synthesize segment, segmentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Avaliar"];
    
    tools       = [[FRTools alloc] initWithTools];
    
    [segmentView setHidden:NO];
    [segmentView setBackgroundColor:COLOR_DEFAULT];
    [segment setTintColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    primaryLogs = [tools propertyListRead:PLIST_LOGS];
    
    // ..
    if (![super hasEnteredPINCode])
    {
        NetworkPIN *vc = [[NetworkPIN alloc] initWithTitle:@"Insira o PIN e avalie o XVI Encontro Anual da REDE PAEX."];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nv animated:NO completion:nil];
    }
    else
        // ...
        [self handleContentUpdate];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) chooseSegment:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    EvaluateOption index = [segmentedControl selectedSegmentIndex];
    
    switch (index) {
        // ..
        case kOptionEvent:
        {
            NSDictionary *logsTemp = [tools propertyListRead:PLIST_LOGS];
            if ([[logsTemp objectForKey:KEY_HAS_EVALUATED_EVENT] isEqualToString:KEY_YES])
            {
                NetworkThanks *vc = [[NetworkThanks alloc] initWithGenericThanks:@"Seus comentários sobre o evento foram computados com sucesso. Agradecemos sua colaboração."];
                [[self navigationController] pushViewController:vc animated:YES];
            }
            else {
                AvalEvent *vc = [[AvalEvent alloc] initWithNibName:NIB_AVAL_EVENT bundle:nil];
                [[self navigationController] pushViewController:vc animated:YES];
            }
        }
            break;
        // ..
        case kOptionStruct:
        {
            // ...
            [self setTableToStructure];
        }
            break;
        // ..
        case kOptionLectures:
        {
            // ...
            [self setTableToLectures];
        }
            break;
    }
}

#pragma mark -
#pragma mark Methods

- (void)setInfo
{
    NSArray *agenda = [tools propertyListRead:PLIST_AGENDA];
    dataLectures = [NSMutableArray array];
    
    for (NSArray *day in agenda)
        for (NSDictionary *lecture in day)
            if (![[lecture objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_BREAK])
                [dataLectures addObject:lecture];
    
    [segment setSelectedSegmentIndex:0];
    [self setTableToLectures];
    
    //..
    [self showTinyLoadView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // ...
        [tools downloadDataFrom:URL_AGENDA_SCORES success:^{
            //...
            [self hideTinyLoadView];
            NSDictionary *returnData = [tools JSONData];
            plistScores    = [returnData objectForKey:KEY_DATA];
            // save..
            [tools propertyListWrite:plistScores forFileName:PLIST_AGENDA_SCORES];
            // ...
            [self setScores];
        } fail:^{
            // ..
            [tools dialogWithMessage:@"Não foi possível carregar as avaliações. Verifique sua conexão à internet para tentar novamente."];
        }];
    });
}
- (void)setScores
{
    [table reloadData];
}

- (void) handleContentUpdate
{
    plist       = [tools propertyListRead:PLIST_AGENDA];
    dataOthers  = [tools propertyListRead:PLIST_AVAL];
    
    if ([plist count] > 0)
        [self setInfo];
    
    [tools requestUpdateFrom:URL_AGENDA_VERSION success:^{
        // ...
        NSString *version = [tools upData];
        NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
        if (![[logs objectForKey:LOG_AGENDA_VERSION] isEqualToString:version]
        ||  [plist count] == 0)
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
            plist    = [returnData objectForKey:KEY_DATA];
            // save..
            [tools propertyListWrite:plist forFileName:PLIST_AGENDA];
            // load..
            [self setInfo];
        } fail:^{
            // ..
            [self hideTinyLoadView];
            //[tools dialogWithMessage:@"Não foi possível carregar a nova versão deste conteúdo. Verifique sua conexão à internet para tentar novamente."];
        }];
    });
}

- (NSString*) scoreForSlug:(NSString*) slug
{
    NSDictionary *dict;
    NSArray *scores = [tools propertyListRead:PLIST_AGENDA_SCORES];
    
    for (NSDictionary *info in scores)
        if ([[info objectForKey:KEY_SLUG] isEqualToString:slug])
            dict = info;
    
    return [dict objectForKey:KEY_SCORE];
}

/**/

- (BOOL) isLectureEvaluated:(NSString*) slug
{
    NSDictionary *logs  = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", KEY_LECTURE_EVALUATED, slug];
    
    if ([logs objectForKey:logKey])
        return YES;
    else
        return NO;
}

/**/

- (void) setTableToLectures
{
    tableData = [dataLectures copy];
    [table reloadData];
}
- (void) setTableToStructure
{
    tableData = [dataOthers copy];
    [table reloadData];
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
    if ([segment selectedSegmentIndex] == kOptionLectures)
        return 90.0;
    else
        return 63.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell             = nil; //[tableView dequeueReusableCellWithIdentifier:@"agendaCell"];
    
    // ...
    // lectures
    if ([segment selectedSegmentIndex] == kOptionLectures)
    {
        if (!cell)
            cell    = (AvalCell*)[xib objectAtIndex:kCellAval];
        
        // ...
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_LIGHT size:16]];
        [[cell labSubtitle] setFont:[UIFont fontWithName:FONT_LIGHT size:10]];
        [[cell labLabel] setFont:[UIFont fontWithName:FONT_LIGHT size:10]];
        [[cell labValue] setFont:[UIFont fontWithName:FONT_REGULAR size:25]];
        
        [[cell labTitle] setText:[dict objectForKey:KEY_TITLE]];
        [[cell labSubtitle] setText:[dict objectForKey:KEY_SUBTITLE]];
        
        if ([self isLectureEvaluated:[dict objectForKey:KEY_SLUG]])
        {
            [[cell imgBall] setImage:[UIImage imageNamed:@"aval_ball_green.png"]];
            [[cell imgArrow] setHidden:YES];
            [[cell imgTick] setHidden:NO];
            [[cell labLabel] setText:@"Sua nota"];
            // ..
            NSString *key = [NSString stringWithFormat:@"%@_%@", KEY_LECTURE_EVALUATED, [dict objectForKey:KEY_SLUG]];
            [[cell labValue] setText:[primaryLogs objectForKey:key]];
        }
        else
        {
            [[cell imgBall] setImage:[UIImage imageNamed:@"aval_ball_blue.png"]];
            [[cell imgArrow] setHidden:NO];
            [[cell imgTick] setHidden:YES];
            [[cell labLabel] setText:@"Média"];
            [[cell labValue] setText:[self scoreForSlug:[dict objectForKey:KEY_SLUG]]];
        }
    }
    // ...
    // structure
    else
    {
        if (!cell)
            cell    = (AvalStructCell*)[xib objectAtIndex:kCellAvalStruct];
        
        // ...
        [[cell labText] setText:[dict objectForKey:KEY_LABEL]];
        
        if ([self isLectureEvaluated:[dict objectForKey:KEY_SLUG]])
        {
            [[cell labText] setFont:[UIFont fontWithName:FONT_LIGHT size:16]];
            [[cell imgArrow] setHidden:YES];
            [[cell imgTick] setHidden:NO];
        }
        else
        {
            [[cell labText] setFont:[UIFont fontWithName:FONT_BOLD size:16]];
            [[cell imgArrow] setHidden:NO];
            [[cell imgTick] setHidden:YES];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    
    if ([segment selectedSegmentIndex] == kOptionLectures
    ||  ([segment selectedSegmentIndex] == kOptionStruct && ![self isLectureEvaluated:[dict objectForKey:KEY_SLUG]]))
    {
        EvaluateOption evalopt = segment.selectedSegmentIndex;
        AvalSingle *vc = [[AvalSingle alloc] initWithDictionary:dict andOption:evalopt];
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"Seus comentários sobre \"%@\" foram computados com sucesso. Agradecemos sua colaboração.", [dict objectForKey:KEY_LABEL]];
        NetworkThanks *vc = [[NetworkThanks alloc] initWithGenericThanks:str];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

@end
