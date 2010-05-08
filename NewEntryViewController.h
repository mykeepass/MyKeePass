//
//  NewEntryTableViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/12/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KdbLib.h>
#import "TextFieldCell.h"
#import "TKTextViewCell.h"

@interface NewEntryViewController : UITableViewController {
	id<KdbGroup> _parent;

	TextFieldCell * _entryname;	
	TextFieldCell * _username;
	TextFieldCell * _password1;
	TextFieldCell * _password2;
	TextFieldCell * _url;
	
	TKTextViewCell * _comment;
}

@property(nonatomic, retain) id<KdbGroup> _parent;

@property(nonatomic, retain) TextFieldCell * _entryname;
@property(nonatomic, retain) TextFieldCell * _username;
@property(nonatomic, retain) TextFieldCell * _password1;
@property(nonatomic, retain) TextFieldCell * _password2;
@property(nonatomic, retain) TextFieldCell * _url;
@property(nonatomic, retain) TKTextViewCell * _comment;

-(IBAction)cancelClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;

@end
