//
//  MyKeePassAppDelegate.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright Qiang Yu 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MyKeePassAppDelegate.h"

@implementation MyKeePassAppDelegate
@synthesize window;
@synthesize _fileManager;
@synthesize _kdbView;
@synthesize _mainView;
@synthesize _currentViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	//initialize the file manager
	_fileManager = [[FileManager alloc]init];
	
	//initialize the main view
	_mainView = [[MainViewController alloc]init];	
	
	self._currentViewController = _mainView;
	
	[window addSubview:_mainView.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[_mainView release];
	[_kdbView release];
    [window release];
	[_fileManager release];
	[_currentViewController release];
    [super dealloc];
}

-(void)showKdb{
	if(![_currentViewController isKindOfClass:[KdbViewController class]]){
		[_currentViewController.view removeFromSuperview];
		id<KdbReader> kdbReader = _fileManager._kdbReader;
		
		if(!_kdbView){
			_kdbView = [[KdbViewController alloc]initWithGroup:[[kdbReader getKdbTree] getRoot]];			
		}
		
		self._currentViewController = _kdbView;
		
		[window addSubview:_currentViewController.view];
		
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionFade];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[window layer] addAnimation:animation forKey:@"SwitchToKdbView"];	
	}
}

-(void)showMainView{
	if(![_currentViewController isKindOfClass:[MainViewController class]]){
		[_currentViewController.view removeFromSuperview];
		_fileManager._kdbReader = nil;
		self._kdbView = nil;
					
		if(!_mainView)	
			_mainView = [[MainViewController alloc]init];	
		
		self._currentViewController = _mainView;
		
		[window addSubview:_currentViewController.view];
		
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionFade];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[window layer] addAnimation:animation forKey:@"SwitchToMainView"];	
	}	
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
	if([_currentViewController isKindOfClass:[KdbViewController class]]){
		[_currentViewController.view removeFromSuperview];
		
		PasswordViewController * lockWindow = [[PasswordViewController alloc] initWithFileName:_fileManager._filename remote:NO];
		lockWindow._isReopen = YES;
		
		self._currentViewController = lockWindow;
		[window addSubview:lockWindow.view];
		[lockWindow release];
	}
}

-(BOOL)isEditable{
	return _fileManager._editable;
}

+(MyKeePassAppDelegate *)delegate{
	return (MyKeePassAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(UIWindow *)getWindow{
	return ((MyKeePassAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
}
@end
