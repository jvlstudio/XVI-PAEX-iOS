//
//  KDBarButton.h
//  HSM
//
//  Created by Felipe Ricieri on 02/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDBarButton : UIBarButtonItem

- (id) initWithMenu:(SEL)selector toTarget:(id)target;
- (id) initWithBack:(SEL)selector toTarget:(id)target;
- (id) initWithClose:(SEL)selector toTarget:(id)target;

@end
