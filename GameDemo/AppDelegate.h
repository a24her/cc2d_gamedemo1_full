//
//  AppDelegate.h
//  GameDemo
//
//  Created by Juhyoung Kim on 12. 7. 3..
//  Copyright Home 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
