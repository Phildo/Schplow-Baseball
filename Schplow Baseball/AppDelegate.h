//
//  AppDelegate.h
//  Schplow Baseball
//
//  Created by Philip Dougherty on 8/11/11.
//  Copyright UW Madison 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
