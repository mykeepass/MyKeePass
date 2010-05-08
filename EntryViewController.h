//
//  EntryViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/7/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kdb.h>
#import "PasswordDisclosureView.h"

@interface EntryViewController : UITableViewController <UIActionSheetDelegate> {
	id<KdbEntry> _entry;
	BOOL _passwordShown;
	
	PasswordDisclosureView * _passwordDisclosureView;
}

@property(nonatomic, readonly) id<KdbEntry> _entry;
@property(nonatomic, retain) PasswordDisclosureView * _passwordDisclosureView;

-(id)initWithEntry:(id<KdbEntry>)entry;
-(IBAction)editClicked:(id)sender;
-(void)dismissModalViewCancel:(NSNotification *)notification;
-(void)dismissModalViewDone:(NSNotification *)notification;

-(IBAction)viewPasswordClicked:(id)sender;
@end
