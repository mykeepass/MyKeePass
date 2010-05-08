//
//  OptionViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/24/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "OptionViewController.h"
#import "TextFieldCell.h"
#import "MyKeePassAppDelegate.h"

@implementation OptionViewController
@synthesize _password1;
@synthesize _password2;
@synthesize _op;
@synthesize _av;

- (id)init {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		_password1 = [[TextFieldCell alloc] initWithIdentifier:nil];
		_password2 = [[TextFieldCell alloc] initWithIdentifier:nil];
		
		_password1._field.secureTextEntry = YES;
		_password1._field.clearsOnBeginEditing = YES;
		_password1._field.text=@"";
		_password1._field.placeholder = NSLocalizedString(@"New Master Password", @"New Master Password");
		_password1.selectionStyle = UITableViewCellSelectionStyleNone;		

		_password2._field.secureTextEntry = YES;
		_password2._field.clearsOnBeginEditing = YES;
		_password2._field.text=@"";
		_password2._field.placeholder = NSLocalizedString(@"Retype Master Password", @"Retype Master Password");	
		_password2.selectionStyle = UITableViewCellSelectionStyleNone;			
		
		if(![MyKeePassAppDelegate delegate]._fileManager._editable){
			_password1._field.placeholder = NSLocalizedString(@"File is readonly", @"File is readonly");
			_password2._field.placeholder = NSLocalizedString(@"File is readonly", @"File is readonly");
			_password1._field.enabled = _password2._field.enabled = NO;			
		}
    }
    return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath row]==0){
		return _password1;
	}else{
		return _password2;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView * container = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,100)]; 
	UIButton * ok = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	ok.frame = CGRectMake(11,16,143,35); 
	[ok setTitle:NSLocalizedString(@"OK", @"OK") forState:UIControlStateNormal];
	UIButton * cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancel.frame = CGRectMake(165, 16, 143, 35);
	[cancel setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
	[container addSubview:ok];
	[container addSubview:cancel];
	[cancel addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
	[ok addTarget:self action:@selector(okClicked:) forControlEvents:UIControlEventTouchUpInside];
	ok.enabled = cancel.enabled = [MyKeePassAppDelegate delegate]._fileManager._editable;
	return [container autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50;
}

-(IBAction)cancelClicked:(id)sender{
	_password1._field.text = _password2._field.text = @"";
	[_password1._field resignFirstResponder];
	[_password2._field resignFirstResponder];	
}

-(IBAction)okClicked:(id)sender{
	if([_password1._field.text length]==0){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Password cannot be empty", @"Password cannot be empty") delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];	
		[alert show];
		[alert release];		
		return;
	}
	
	if(![_password1._field.text isEqualToString:_password2._field.text]){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Passwords don't match", @"Passwords don't match") delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];	
		[alert show];
		[alert release];
	}else{
		if(!_op) _op = [[FileManagerOperation alloc] initWithDelegate:self];
		if(!_av) _av = [[ActivityView alloc] initWithFrame:CGRectMake(0,0,320,480)];	 
		
		_oldPassword = [[MyKeePassAppDelegate delegate]._fileManager._password retain];
		[MyKeePassAppDelegate delegate]._fileManager._password = _password1._field.text;
		[MyKeePassAppDelegate delegate]._fileManager._dirty = YES;

		[self.view addSubview:_av];
		[_op performSelectorInBackground:@selector(save) withObject:nil];
		
		[_password1._field resignFirstResponder];
		[_password2._field resignFirstResponder];	
	}
}

-(void)fileOperationSuccess{
	[_av removeFromSuperview];	
	UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
													message:NSLocalizedString(@"Password changed successfully", @"Password changed successfully") delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
										  otherButtonTitles:nil];	
	[alert show];
	[alert release];
}

-(void)fileOperationFailureWithException:(NSException *)exception{
	[_av removeFromSuperview];
	[MyKeePassAppDelegate delegate]._fileManager._password = _oldPassword;			
	[_oldPassword release];
	UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
													message:NSLocalizedString(@"Error Saving File", @"Error Saving File") delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
										  otherButtonTitles:nil];	
	[alert show];
	[alert release];
}

- (void)dealloc {
	[_password1 release];
	[_password2 release];
	[_av release];
	[_op release];
	[super dealloc];
}


@end

