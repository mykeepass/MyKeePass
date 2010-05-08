//
//  OptionViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/24/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h";
#import "FileManagerOperation.h"
#import "ActivityView.h"

@interface OptionViewController : UITableViewController<FileManagerOperationDelegate> {
	TextFieldCell * _password1;
	TextFieldCell * _password2;
	
	FileManagerOperation * _op;
	ActivityView * _av;	
	NSString * _oldPassword;
}

@property(nonatomic, retain)TextFieldCell * _password1;
@property(nonatomic, retain)TextFieldCell * _password2;

@property(nonatomic, retain) FileManagerOperation * _op;
@property(nonatomic, retain) ActivityView * _av;

-(IBAction)cancelClicked:(id)sender;
-(IBAction)okClicked:(id)sender;
@end
