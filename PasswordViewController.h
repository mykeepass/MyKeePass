//
//  PasswordViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/8/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h"
#import "ActivityView.h"
#import "FileManagerOperation.h"

@interface PasswordViewController : UITableViewController<FileManagerOperationDelegate, UITextFieldDelegate>{
	NSString * _filename;	
	
	FileManagerOperation * _op;
	BOOL _isRemote;	
	BOOL _isReopen;	
	BOOL _isLoading;
	
	ActivityView * _av;
	UIButton * _ok;
	UIButton * _cancel;
	UISwitch * _switch;	
	TextFieldCell * _password;
	UITableViewCell * _useCache;
	TextFieldCell * _rusername;
	TextFieldCell * _rpassword;
	TextFieldCell * _rdomain;
}

@property(nonatomic, retain) NSString * _filename;
@property(nonatomic, assign) BOOL _isRemote;
@property(nonatomic, assign) BOOL _isReopen;
@property(nonatomic, assign) ActivityView * _av;

@property(nonatomic, retain) UIButton * _ok;
@property(nonatomic, retain) UIButton * _cancel;
@property(nonatomic, retain) UISwitch * _switch;

@property(nonatomic, retain) TextFieldCell * _password;
@property(nonatomic, retain) UITableViewCell * _useCache;
@property(nonatomic, retain) TextFieldCell * _rusername;
@property(nonatomic, retain) TextFieldCell * _rpassword;
@property(nonatomic, retain) TextFieldCell * _rdomain;

@property(nonatomic, retain) FileManagerOperation * _op;

- (id)initWithFileName:(NSString *)fileName remote:(BOOL)isRemote;

-(IBAction)cancelClicked:(id)sender;
-(IBAction)okClicked:(id)sender;
@end
