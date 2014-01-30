//
//  AppDelegate.h
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class Home;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBar;

#pragma mark -
#pragma mark Opening Methods

- (UIViewController*) openingWithAnimation;
- (UIViewController*) openingWithoutAnimation;

@end
