//
//  EventManager.h
//  HSM
//
//  Created by Felipe Ricieri on 03/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (nonatomic, strong) NSDictionary *event;
@property (nonatomic, strong) NSArray *panelists;
@property (nonatomic, strong) NSArray *agenda;
@property (nonatomic, strong) NSArray *passes;

#pragma mark -
#pragma mark Init Methods

- (id) init;
- (id) initWithEvent:(NSDictionary*) eventDict;
- (void) setConfigurations;

#pragma mark -
#pragma mark Search Methods

- (BOOL) isPanelistScheduled:(NSString*) slug;

#pragma mark -
#pragma mark Save Methods

- (void) saveAtLogs:(NSDictionary*) dict;
- (void) removeAtLogs:(NSDictionary*) dict;
- (void) saveEKEventOnCalendar:(NSDictionary*) dict;

#pragma mark -
#pragma mark Event Methods

- (void) askForEKEventPermission;
- (BOOL) isAbleToSaveEKEvents;

@end
