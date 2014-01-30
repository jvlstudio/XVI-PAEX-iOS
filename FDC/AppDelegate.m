//
//  AppDelegate.m
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "Opening.h"

#import "Home.h"
#import "Agenda.h"
#import "Panelist.h"
#import "Network.h"
#import "Aval.h"

@interface AppDelegate ()
- (void) configureTabBar;
@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Let the device know we want to receive push notifications
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_APP_SECRET];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
	[application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	// local notifications..
    [application cancelAllLocalNotifications];
    
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.rootViewController = [self openingWithAnimation]; //self.tabBar;
    [self.window makeKeyAndVisible];
    
    // ...
    //[self customizeAppearance];
    
    // return..
    return YES;
}

#pragma mark -
#pragma mark Opening Methods

- (UIViewController*) openingWithAnimation
{
    Opening *opening = [[Opening alloc] initWithNibName:NIB_OPENING bundle:nil];
    return opening;
}
- (UIViewController*) openingWithoutAnimation
{
    // set tab bar..
    self.tabBar = [[UITabBarController alloc] init];
    [self configureTabBar];
    
    return [self tabBar];
}

#pragma mark -
#pragma mark Methods

- (void) configureTabBar
{
    // vcs..
    Home *vcHome        = [[Home alloc] initWithNibName:NIB_HOME bundle:nil];
    Agenda *vcAgenda    = [[Agenda alloc] initWithNibName:NIB_AGENDA bundle:nil];
    Panelist *vcPanelist= [[Panelist alloc] initWithNibName:NIB_PANELIST bundle:nil];
    Network *vcNetwork  = [[Network alloc] initWithNibName:NIB_NETWORK bundle:nil];
    Aval *vcAval        = [[Aval alloc] initWithNibName:NIB_AVAL bundle:nil];
    
    // tab bar items..
    UITabBarItem *tabHome, *tabAgenda, *tabPanelist, *tabNetwork, *tabAval;
    UINavigationController *navHome, *navAgenda, *navPanelist, *navNetwork, *navAval;
    
    // home..
    UIImage *homeOn     = [UIImage imageNamed:TAB_HOME_ON];
    UIImage *homeOff    = [UIImage imageNamed:TAB_HOME_OFF];
    homeOn              = [homeOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeOff             = [homeOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabHome = [[UITabBarItem alloc] initWithTitle:nil
                                            image:homeOff selectedImage:homeOn];
    [vcHome setTabBarItem:tabHome];
    navHome     = [[UINavigationController alloc] initWithRootViewController:vcHome];
    
    // agenda
    UIImage *agendaOn   = [UIImage imageNamed:TAB_AGENDA_ON];
    UIImage *agendaOff  = [UIImage imageNamed:TAB_AGENDA_OFF];
    agendaOn            = [agendaOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    agendaOff           = [agendaOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabAgenda = [[UITabBarItem alloc] initWithTitle:nil
                                              image:agendaOff selectedImage:agendaOn];
    [vcAgenda setTabBarItem:tabAgenda];
    navAgenda   = [[UINavigationController alloc] initWithRootViewController:vcAgenda];
    
    // panelist
    UIImage *panOn      = [UIImage imageNamed:TAB_PANELIST_ON];
    UIImage *panOff     = [UIImage imageNamed:TAB_PANELIST_OFF];
    panOn               = [panOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    panOff              = [panOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabPanelist = [[UITabBarItem alloc] initWithTitle:nil
                                                image:panOff selectedImage:panOn];
    [vcPanelist setTabBarItem:tabPanelist];
    navPanelist = [[UINavigationController alloc] initWithRootViewController:vcPanelist];
    
    // netwrok
    UIImage *netOn      = [UIImage imageNamed:TAB_NETWORK_ON];
    UIImage *netOff     = [UIImage imageNamed:TAB_NETWORK_OFF];
    netOn               = [netOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    netOff              = [netOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabNetwork = [[UITabBarItem alloc] initWithTitle:nil
                                               image:netOff selectedImage:netOn];
    [vcNetwork setTabBarItem:tabNetwork];
    navNetwork  = [[UINavigationController alloc] initWithRootViewController:vcNetwork];
    
    // aval
    UIImage *avaOn      = [UIImage imageNamed:TAB_AVAL_ON];
    UIImage *avaOff     = [UIImage imageNamed:TAB_AVAL_OFF];
    avaOn               = [avaOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    avaOff              = [avaOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabAval = [[UITabBarItem alloc] initWithTitle:nil
                                               image:avaOff selectedImage:avaOn];
    [vcAval setTabBarItem:tabAval];
    navAval  = [[UINavigationController alloc] initWithRootViewController:vcAval];
    
    // set view controllers..
    NSArray *views      = [NSArray arrayWithObjects:navHome, navAgenda, navPanelist, navNetwork, navAval, nil];
    CGRect rectTab      = self.tabBar.tabBar.frame;
    rectTab.size.height = 59;
    rectTab.origin.y    = WINDOW_HEIGHT-rectTab.size.height;
    [[[self tabBar] tabBar] setFrame:rectTab];
    [[self tabBar] setViewControllers:views];
}

#pragma mark -
#pragma mark UIDevice Methods

- (void) customizeAppearance
{
	// Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      NSForegroundColorAttributeName,
      [[NSShadow alloc] shadowBlurRadius],
      NSShadowAttributeName,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      NSFontAttributeName,
      nil]];
}

#pragma mark -
#pragma mark APNS Configuration

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification: App está ativo.");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PFPush storeDeviceToken:devToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !TARGET_IPHONE_SIMULATOR
	NSLog(@"Error in registration. Error: %@", error);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

@end
