//
//  MyKeePassAppDelegate.m
//  MyKeePass
//
//  Created by Qiang Yu on 12/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MyKeePassAppDelegate.h"

@implementation MyKeePassAppDelegate

@synthesize window;
@synthesize _mainViewController;
@synthesize _databaseWrapper;

-(id)init{
	if(self==[super init]){
		self._databaseWrapper = [[DatabaseWrapper alloc]init];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview:_mainViewController.view];
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
	[_mainViewController release];
	[_databaseWrapper release];
    [super dealloc];
}


-(void)switchViews{
	[_mainViewController switchViews];
}

- (void)applicationWillResignActive:(UIApplication *)application{
	//clean views e.g. dismiss modal views such as TableTextFieldEditViewController
	[_mainViewController cleanViews];
	[_databaseWrapper saveDatabase];
	_databaseWrapper._database = nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
	///
	//switch the view to fileview whenever the application becomes active
	///
	if(!_mainViewController._fileViewController.view.superview){
		[self switchViews];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application{
	[_databaseWrapper saveDatabase];
}


@end
