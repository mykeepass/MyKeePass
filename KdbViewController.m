//
//  KdbViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/6/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "KdbViewController.h"
#import "GroupViewController.h"
#import "MyKeePassAppDelegate.h"
#import "EntrySearchViewController.h"
#import "OptionViewController.h"


@implementation KdbViewController
@synthesize _tabBarController;
@synthesize _group;

-(id)initWithGroup:(id<KdbGroup>)group{
	if(self=[super init]){
		_group = [group retain];
	}
	return self;
}


- (void)dealloc {
	[_group release];
	[_tabBarController release];	
    [super dealloc];
}

- (void)loadView {
	//set the rootview
	UIView * contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = contentView;
	
	//the group view	
	GroupViewController * groupView = nil;
	if([[MyKeePassAppDelegate delegate]._fileManager getKDBVersion]==KDB_VERSION1){
		groupView = [[GroupViewController alloc]initWithGroup:_group];
		groupView._isRoot = YES;
	}else{
		groupView = [[GroupViewController alloc]initWithGroup:(id<KdbGroup>)[[_group getSubGroups]objectAtIndex:0]];
	}
	
	UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:groupView];
	
	if(groupView._isRoot){ //KDB1
		NSString * filename = [MyKeePassAppDelegate delegate]._fileManager._filename;
		if([filename hasSuffix:@".kdb"])
			groupView.navigationItem.title = [filename substringToIndex:[filename length]-4];
		else
			groupView.navigationItem.title = filename;
	}
	
	groupView.tabBarItem.image = [UIImage imageNamed:@"passwords.png"];
	groupView.tabBarItem.title = NSLocalizedString(@"Passwords", @"Passwords");
	
	//the search view controller
	EntrySearchViewController * searchView = [[EntrySearchViewController alloc]init];
	UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:searchView];
	searchView._group = groupView._group;
	searchView.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	
	searchView.tabBarItem = [[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0]autorelease];
	
	//the option view controller
	OptionViewController * optionView = [[OptionViewController alloc]init];
	UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:optionView];
	optionView.navigationItem.title = NSLocalizedString(@"Change Password", @"Change Password");
	
	optionView.tabBarItem.image = [UIImage imageNamed:@"options.png"]; 
	optionView.tabBarItem.title = NSLocalizedString(@"Options", @"Options"); 
	
	
	//a dummy view controller
	UIViewController * dummy = [[UIViewController alloc]init];
	dummy.tabBarItem.image = [UIImage imageNamed:@"files.png"];
	dummy.tabBarItem.title = NSLocalizedString(@"KDB Files", @"KDB Files");	
	
	//the tab bar
	_tabBarController = [[UITabBarController alloc]init];	
	_tabBarController.delegate = self;
	NSArray * controllers = [NSArray arrayWithObjects:nav, nav2, nav3, dummy, nil];
	_tabBarController.viewControllers = controllers;
	
	[self.view addSubview:_tabBarController.view];
	
	//release
	[contentView release];	
	[groupView release];
	[searchView release];
	[optionView release];	
	[dummy release];
	[nav release];
	[nav2 release];
	[nav3 release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex){
		[[MyKeePassAppDelegate delegate] showMainView];
	}
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
	if([viewController isMemberOfClass:[UIViewController class]]){
		UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Closing File", @"Closing File") 
															message:NSLocalizedString(@"Are you sure you want to leave the password file?", @"Close file confirmation")
														   delegate:self cancelButtonTitle:NSLocalizedString(@"No", "No")
												  otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];		
		[alertView show];
		[alertView release];
		return NO;
	}else
		return YES;
}

@end
