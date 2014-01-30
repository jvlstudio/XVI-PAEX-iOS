//
//  EventManager.m
//  HSM
//
//  Created by Felipe Ricieri on 03/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "EventManager.h"

#define LOG_EKEVENT             @"ekEvent"

@interface EventManager()

@end

@implementation EventManager
{
    FRTools *tools;
    NSArray *propertyList;
}

@synthesize event;
@synthesize panelists;
@synthesize agenda;
@synthesize passes;

#pragma mark -
#pragma mark Init Methods

- (id) init
{
    [self setConfigurations];
    return self;
}
- (id) initWithEvent:(NSDictionary*) eventDict
{
    [self setConfigurations];
    
    event = eventDict;
    
    return self;
}
- (void) setConfigurations
{
    tools           = [[FRTools alloc] initWithTools];
    propertyList    = [tools propertyListRead:PLIST_AGENDA];
}

#pragma mark -
#pragma mark Methods

- (BOOL) isPanelistScheduled:(NSString*) slug
{
    NSDictionary *logs  = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", KEY_EVENT_SCHEDULED, slug];
    if ([[logs objectForKey:logKey] isEqualToString:KEY_YES])
        return YES;
    else
        return NO;
}

#pragma mark -
#pragma mark Save Methods

- (void)saveAtLogs:(NSDictionary *)dict
{
    NSLog(@"EKEVENT: - Start to save to Logs");
    // save to plist log..
    NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey = [NSString stringWithFormat:@"%@_%@", KEY_EVENT_SCHEDULED, [dict objectForKey:KEY_SLUG]];
    [logs setObject:KEY_YES forKey:logKey];
    [tools propertyListWrite:logs forFileName:PLIST_LOGS];
}
- (void)removeAtLogs:(NSDictionary *)dict
{
    NSLog(@"EKEVENT: - Start to remove to Logs");
    // save to plist log..
    NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    NSString *logKey = [NSString stringWithFormat:@"%@_%@", KEY_EVENT_SCHEDULED, [dict objectForKey:KEY_SLUG]];
    if ([logs objectForKey:logKey])
        [logs removeObjectForKey:logKey];
    [tools propertyListWrite:logs forFileName:PLIST_LOGS];
}
- (void) saveEKEventOnCalendar:(NSDictionary*) dict
{
    if ([self isAbleToSaveEKEvents])
    {
        NSLog(@"EKEVENT: - Start to save to iCal");
        NSArray *hoursToAdd = [dict objectForKey:KEY_GMTC];
        // ...
        for (NSDictionary *dict in hoursToAdd)
        {
            int interval = [[dict objectForKey:KEY_MINUTES] intValue] * 60; // transform minutes into hours..
            EKEventStore *eventStore    = [[EKEventStore alloc] init];
            EKEvent *ekEvent            = [EKEvent eventWithEventStore:eventStore];
            EKAlarm *alarm              = [EKAlarm alarmWithRelativeOffset:60.0f * -20.0f]; // 20 min
            
            NSString *eventTit  = [NSString stringWithFormat:@"HSM: %@ (Palestra)", [dict objectForKey:KEY_NAME]];
            
            ekEvent.title       = eventTit;
            ekEvent.startDate   = [dict objectForKey:KEY_DATE];
            ekEvent.endDate     = [[NSDate alloc] initWithTimeInterval:interval sinceDate:ekEvent.startDate];
            ekEvent.notes       = [dict objectForKey:KEY_DESCRIPTION];
            [ekEvent addAlarm:alarm];
            
            // save to ical..
            NSError *err;
            [ekEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
            if ([eventStore saveEvent:ekEvent span:EKSpanThisEvent error:&err])
            {
                NSLog(@"EKEVENT: - Saved to iCal");
                // save to plist log..
                NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
                NSString *logKey = [NSString stringWithFormat:@"%@_%@", KEY_EVENT_SCHEDULED, [dict objectForKey:KEY_SLUG]];
                [logs setObject:KEY_YES forKey:logKey];
                [tools propertyListWrite:logs forFileName:PLIST_LOGS];
                // read (again) and print..
                NSDictionary *logs2 = [tools propertyListRead:PLIST_LOGS];
                NSLog(@"%@", logs2);
            }
            else
                NSLog(@"EKEVENT: - NOT Saved to iCal");
        }
    }
    else {
        // ask..
        NSLog(@"EKEVENT: - Ask before save to iCal");
        [self askForEKEventPermission];
    }
}

#pragma mark -
#pragma mark Event Methods

- (void) askForEKEventPermission
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSLog(@"EKEVENT: - Granted");
             NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
             [logs setObject:KEY_YES forKey:LOG_EKEVENT];
             [tools propertyListWrite:logs forFileName:PLIST_LOGS];
         }
         // not allowed
         else {
             NSLog(@"EKEVENT: - Else Granted");
             [tools dialogWithMessage:@"Para que o App HSM Inspiring Ideas possa salvar lembretes das palestras em seu calendário, é necessário que você libere esta permissão em seu iPhone."];
         }
     }];
}
- (BOOL) isAbleToSaveEKEvents
{
    NSDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    
    if([[logs objectForKey:LOG_EKEVENT] isEqualToString:KEY_YES])
        //if ([self askForEKEventPermission])
        return YES;
    
    return NO;
}

@end
