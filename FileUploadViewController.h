//
//  FileUploadViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/21/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"

@interface FileUploadViewController : UITableViewController {
	HTTPServer * _httpServer;
}

@property(nonatomic, retain) HTTPServer * _httpServer;

-(IBAction)doneClicked:(id)sender;
- (void)displayInfoUpdate:(NSNotification *) notification;

@end
