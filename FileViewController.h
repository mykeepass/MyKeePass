//
//  FileViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileViewController : UITableViewController<UIActionSheetDelegate, UIAlertViewDelegate> {
	NSMutableArray * _files;
	NSMutableArray * _remoteFiles;
	NSIndexPath * _rowToDelete;
}

@property(nonatomic, retain) NSIndexPath * _rowToDelete;

-(IBAction)addFile:(id)sender;
-(void)dismissModalViewCancel:(NSNotification *)notification;
-(void)dismissModalViewOK:(NSNotification *)notification;
@end
