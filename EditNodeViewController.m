//
//  EditNodeViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/15/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "EditNodeViewController.h"
#import "TextFieldCell.h"
#import "MyKeePassAppDelegate.h"

#define USERNAME_ROW	0
#define PASSWORD_ROW1	1
#define PASSWORD_ROW2	2
#define WEBSITE_ROW		3

#define COMMENT_ROW		0

@implementation EditNodeViewController

@synthesize _entry;
@synthesize _op;
@synthesize _av;

@synthesize _username;
@synthesize _password1;
@synthesize _password2;
@synthesize _url;
@synthesize _comment;

-(void)dealloc {
	[_op release];
	[_av release];
	[_comment release];
	[_url release];
	[_password2 release];
	[_password1 release];
	[_username release];
	[_entry release];
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") 
															   style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
	
	self.navigationItem.title = [_entry getEntryName];
	
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done") 
															 style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = done;
	
	_username = [[TextFieldCell alloc] initWithIdentifier:nil];
	_username._field.placeholder = NSLocalizedString(@"User Name", @"User Name");				
	_username._field.text = [_entry getUserName];	
	if(!_username._field.text) _username._field.text = @"";
	_username.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_password1 = [[TextFieldCell alloc] initWithIdentifier:nil];
	_password1._field.placeholder = NSLocalizedString(@"Password", @"Password"); 	
	_password1._field.text = [_entry getPassword];
	_password1._field.secureTextEntry = YES;
	if(!_password1._field.text) _password1._field.text = @"";
	_password1.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_password2 = [[TextFieldCell alloc] initWithIdentifier:nil];
	_password2._field.placeholder = NSLocalizedString(@"Password", @"Password"); 	
	_password2._field.text = [_entry getPassword];
	_password2._field.secureTextEntry = YES;	
	if(!_password2._field.text) _password2._field.text = @"";	
	_password2.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_url = [[TextFieldCell alloc] initWithIdentifier:nil];	
	_url._field.placeholder = NSLocalizedString(@"URL", @"URL");				
	_url._field.text = [_entry getURL];	
	if(!_url._field.text) _url._field.text = @"";	
	_url._field.keyboardType = UIKeyboardTypeURL;
	_url.selectionStyle = UITableViewCellSelectionStyleNone;
	_url._field.autocapitalizationType = UITextAutocapitalizationTypeNone;	
	
	_comment = (TKTextViewCell *)[[TKTextViewCell alloc]initWithIdentifier:nil];
	_comment.textView.text = [_entry getComments];
	if(!_comment.textView.text) _comment.textView.text = @"";	
	_comment.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_op = [[FileManagerOperation alloc] initWithDelegate:self];
	_av = [[ActivityView alloc] initWithFrame:CGRectMake(0,0,320,480)];	
	
	[done release];
}

-(void)viewDidUnload{
	self._username = self._password1 = self._password2 = self._url = self._comment = nil;
	[super viewDidUnload];	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[_username._field becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0)
		return 4;
	else 
		return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if([indexPath section]==0) 
		return 40;
	else	
		return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section]==0){		
		switch (indexPath.row) {
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
	}else 
		return _comment;	
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
		
		[_entry setUserName:_username._field.text];
		[_entry setPassword:_password1._field.text];
		[_entry setURL:_url._field.text];
		[_entry setComments:_comment.textView.text];

		NSDate * now = [NSDate date];
		[_entry setLastMod:now];
		[_entry setLastAccess:now];
		
		fm._dirty = YES;	
		[self.view addSubview:_av];
		[_op performSelectorInBackground:@selector(save) withObject:nil];
	}
}

-(void)fileOperationSuccess{
	[_av removeFromSuperview];	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EntryUpdated" object:nil];					
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewDone" object:self];
}

-(void)fileOperationFailureWithException:(NSException *)exception{
	[_av removeFromSuperview];
	UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
													message:NSLocalizedString(@"Error Saving File", @"Error Saving File") delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
										  otherButtonTitles:nil];	
	[alert show];
	[alert release];	
}
@end

