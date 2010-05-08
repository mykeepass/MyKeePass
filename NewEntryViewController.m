//
//  NewEntryTableViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/12/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "NewEntryViewController.h"
#import "MyKeePassAppDelegate.h"

#define ENTRY_NAME_ROW	0
#define USERNAME_ROW	1
#define PASSWORD_ROW1	2
#define PASSWORD_ROW2	3
#define WEBSITE_ROW		4

#define COMMENT_ROW		0

@implementation NewEntryViewController
@synthesize _parent;
@synthesize _entryname;
@synthesize _username;
@synthesize _password1;
@synthesize _password2;
@synthesize _url;
@synthesize _comment;

- (void)dealloc {
	[_comment release];
	[_url release];
	[_password2 release];
	[_password1 release];
	[_username release];
	[_entryname release];
	[_parent release];
    [super dealloc];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[_entryname._field becomeFirstResponder];
}

-(void)viewDidLoad{
	[super viewDidLoad];	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") 
															style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];

	self.navigationItem.title = NSLocalizedString(@"Add Entry", @"Add Entry");
	
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done") 
															style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = done;
	
	_entryname = [[TextFieldCell alloc] initWithIdentifier:nil];
	_entryname._field.placeholder = NSLocalizedString(@"Entry Name", @"Entry Name");				
	_entryname._field.text = @"";
	_entryname.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_username = [[TextFieldCell alloc] initWithIdentifier:nil];
	_username._field.placeholder = NSLocalizedString(@"User Name", @"User Name");				
	_username._field.text = @"";
	_username.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_password1 = [[TextFieldCell alloc] initWithIdentifier:nil];
	_password1._field.placeholder = NSLocalizedString(@"Password", @"Password"); 
	_password1._field.text = @"";
	_password1._field.secureTextEntry = YES;	
	_password1.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_password2 = [[TextFieldCell alloc] initWithIdentifier:nil];
	_password2._field.placeholder = NSLocalizedString(@"Password", @"Password"); 
	_password2._field.text = @"";	
	_password2._field.secureTextEntry = YES;	
	_password2.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_url = [[TextFieldCell alloc] initWithIdentifier:nil];	
	_url._field.placeholder = NSLocalizedString(@"URL", @"URL");				
	_url._field.text = @"";	
	_url.selectionStyle = UITableViewCellSelectionStyleNone;
	_url._field.keyboardType = UIKeyboardTypeURL;
	_url._field.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	_comment = (TKTextViewCell *)[[TKTextViewCell alloc]initWithIdentifier:nil];
	_comment.textView.text = @"";	
	_comment.selectionStyle = UITableViewCellSelectionStyleNone;

	[done release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self._entryname = self._username = self._password1 = self._password2 = self._url = self._comment = nil;
	[super viewDidUnload];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0)
		return 5;
	else 
		return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section]==0){
		switch (indexPath.row) {
			case ENTRY_NAME_ROW:
				return _entryname;
			case USERNAME_ROW:
				return _username;
			case PASSWORD_ROW1:
				return _password1;
			case PASSWORD_ROW2:
				return _password2;
			case WEBSITE_ROW:
				return _url;
			default:
				return nil;
		}
	}else {
		return _comment;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if([indexPath section]==0) 
		return 40;
	else	
		return 150;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section==0) 
		return NSLocalizedString(@"Entry Fields", @"Entry Fields");
	else {
		return NSLocalizedString(@"Comment", "Comment");
	}
}

-(IBAction)cancelClicked:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewCancel" object:self];	
}

-(IBAction)doneClicked:(id)sender{
	if(![_password1._field.text isEqualToString:_password2._field.text]){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Passwords don't match", @"Passwords don't match") delegate:nil 
														cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
														otherButtonTitles:nil];	
		[alert show];
		[alert release];
	}else{
		FileManager * fm = [MyKeePassAppDelegate delegate]._fileManager;
		if([fm getKDBVersion]==KDB_VERSION1){
			Kdb3Entry * entry =  [[Kdb3Entry alloc]initWithNewUUID];
			
			entry._title = _entryname._field.text;
			entry._username = _username._field.text;
			entry._password = _password1._field.text;
			entry._url = _url._field.text;
			entry._comment = _comment.textView.text;
			
			NSDate * now = [NSDate date];
			[entry setExpiry:nil];
			[entry setLastMod:now];
			[entry setLastAccess:now];
			[entry setCreation:now];
			
			[_parent addEntry:entry];			
			[entry release];
			fm._dirty = YES;
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"EntryUpdated" object:nil];	
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewDone" object:self];	
	}
}

@end

