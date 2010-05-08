//
//  MyKeePassAppDelegate.h
//  MyKeePass
//
//  Created by Qiang Yu on 12/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DatabaseWrapper.h"

@interface MyKeePassAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MainViewController * _mainViewController;
	DatabaseWrapper * _databaseWrapper;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController * _mainViewController;
@property(nonatomic, retain) DatabaseWrapper * _databaseWrapper;

-(void)switchViews;

@end

