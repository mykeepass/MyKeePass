//
//  GroupViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/6/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kdb.h>
#import "GroupedSectionHeader.h"
#import "FileManagerOperation.h"
#import "ActivityView.h"

@interface GroupViewController : UITableViewController <UIAlertViewDelegate, FileManagerOperationDelegate> {
	id<KdbGroup> _group;
	GroupedSectionHeader * _groupSectionHeader;
	GroupedSectionHeader * _entrySectionHeader;	
	
	BOOL _isRoot;
	NSIndexPath * _rowToDelete;
	
	NSArray * _subGroups;
	NSArray * _entries;
	
	ActivityView * _av;
	FileManagerOperation * _op;
}

@property(nonatomic, readonly) id<KdbGroup> _group;
@property(nonatomic, retain) GroupedSectionHeader * _groupSectionHeader;
@property(nonatomic, retain) GroupedSectionHeader * _entrySectionHeader;
@property(nonatomic, assign) BOOL _isRoot;
@property(nonatomic, retain) NSIndexPath * _rowToDelete;
@property(nonatomic, retain) NSArray * _subGroups;
@property(nonatomic, retain) NSArray * _entries;

@property(nonatomic, retain) ActivityView * _av;
@property(nonatomic, retain) FileManagerOperation * _op;

-(id)initWithGroup:(id<KdbGroup>)group;
-(IBAction)addEntry:(id)sender;
-(IBAction)addGroup:(id)sender;

-(void)dismissModalViewCancel:(NSNotification *)notification;
-(void)dismissModalViewDone:(NSNotification *)notification;
@end
