//
//  EntrySearchViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/22/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kdb.h>

@interface EntrySearchViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>{
	NSMutableArray * _entries;
	NSMutableArray * _qualifiedEntries;
	id<KdbGroup>  _group;
	UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) NSMutableArray * _entries;
@property (nonatomic, retain) NSMutableArray * _qualifiedEntries;
@property (nonatomic, retain) id<KdbGroup> _group;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

-(void)refreshData:(NSNotification *)notification;

@end
