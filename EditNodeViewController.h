//
//  EditNodeViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/15/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KdbLib.h>
#import "TextFieldCell.h"
#import "TKTextViewCell.h"
#import "FileManagerOperation.h"
#import "ActivityView.h"

@interface EditNodeViewController : UITableViewController<FileManagerOperationDelegate> {
	id<KdbEntry> _entry;
	FileManagerOperation * _op;
	ActivityView * _av;
	
	TextFieldCell * _username;
	TextFieldCell * _password1;
	TextFieldCell * _password2;
	TextFieldCell * _url;
	
	TKTextViewCell * _comment;
}

@property(nonatomic, retain) id<KdbEntry> _entry;
@property(nonatomic, retain) FileManagerOperation * _op;
@property(nonatomic, retain) ActivityView * _av;

@property(nonatomic, retain) TextFieldCell * _username;
@property(nonatomic, retain) TextFieldCell * _password1;
@property(nonatomic, retain) TextFieldCell * _password2;
@property(nonatomic, retain) TextFieldCell * _url;
@property(nonatomic, retain) TKTextViewCell * _comment;

-(IBAction)cancelClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;

@end
