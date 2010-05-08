//
//  RenameRemoteFileViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/21/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "RenameRemoteFileViewController.h"
#import "TextFieldCell.h"
#import "MyKeePassAppDelegate.h"

#define ROW_NAME 0
#define ROW_URL	 1

@implementation RenameRemoteFileViewController
@synthesize _name;
@synthesize _url;

// Implement loadView to create a view hierarchy programmatically, without using a nib.

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Rename File", @"Rename File");
	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") 
															   style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done") 
															 style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];
	
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell._field becomeFirstResponder];
}

- (void)dealloc {
    [super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NLFVCell";
	
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TextFieldCell alloc] initWithIdentifier:CellIdentifier] autorelease];
    }
	
	cell._field.clearsOnBeginEditing = NO;
	
    switch(indexPath.row){
		case ROW_NAME:{
			cell._field.placeholder= _name;
			cell._field.text = _name;
			cell._field.keyboardType = UIKeyboardTypeDefault;
			cell._field.autocapitalizationType = UITextAutocapitalizationTypeSentences;			
			break;
		}
		case ROW_URL:{
			cell._field.placeholder = _url;
			cell._field.text = _url;
			cell._field.keyboardType = UIKeyboardTypeURL;
			cell._field.autocapitalizationType = UITextAutocapitalizationTypeNone;
			break;
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

-(IBAction)cancelClicked:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewCancel" object:self];
}

-(IBAction)doneClicked:(id)sender{
	TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	NSString * name = [cell._field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if(name==nil||[name length]==0){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Name cannot be empty", @"Name cannot be empty") delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];	
		[alert show];
		[alert release];		
	}else{
		TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		NSString * url = [cell._field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if(url==nil||[url length]==0){
			UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
															message:NSLocalizedString(@"URL cannot be empty", @"URL cannot be empty") delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
												  otherButtonTitles:nil];	
			[alert show];
			[alert release];
		}else{
			if(![name isEqualToString:_name]&&[[MyKeePassAppDelegate delegate]._fileManager getURLForRemoteFile:name]){
				UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
																message:NSLocalizedString(@"A same name already exists", @"Name already exisits") delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
													  otherButtonTitles:nil];	
				[alert show];
				[alert release];
			}else{
				[[MyKeePassAppDelegate delegate]._fileManager deleteRemoteFile:_name];	
				[[MyKeePassAppDelegate delegate]._fileManager addRemoteFile:name Url:url];			
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewOK" object:self];
			}
		}
	}
}

@end

