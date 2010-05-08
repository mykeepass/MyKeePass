//
//  RenameFileViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/21/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RenameFileViewController : UITableViewController{
	NSString * _filename;
}

@property(nonatomic, retain) NSString * _filename;

-(IBAction)cancelClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;

@end
