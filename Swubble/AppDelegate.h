//
//  AppDelegate.h
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright gibfried 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface MainNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MainNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MainNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
