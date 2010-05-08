//
//  MyKeePassAppDelegate.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright Qiang Yu 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "KdbViewController.h"
#import "PasswordViewController.h"
#import "FileManager.h"

@interface MyKeePassAppDelegate : NSObject <UIApplicationDelegate> {
	FileManager * _fileManager;
	
	MainViewController * _mainView;
    KdbViewController * _kdbView;
	
	UIViewController * _currentViewController;
	
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly) FileManager * _fileManager;
@property (nonatomic, retain) MainViewController * _mainView;
@property (nonatomic, retain) KdbViewController * _kdbView;
@property (nonatomic, retain) UIViewController * _currentViewController;

+(MyKeePassAppDelegate *)delegate;
+(UIWindow *)getWindow;

-(void)showKdb;
-(void)showMainView;
-(BOOL)isEditable;
@end

