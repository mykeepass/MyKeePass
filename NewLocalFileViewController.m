//
//  NewLocalFileViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/4/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "NewLocalFileViewController.h"
#import "TextFieldCell.h"
#import "FileManager.h"

#define ROW_FILENAME	0
#define ROW_PASSWORD_1	1
#define ROW_PASSWORD_2	2
#define ROW_VERSION		3

@interface NewLocalFileViewController (PrivateMethods)
-(void)newKDB3File:(NSString *)filename withPassword:(NSString *)password;
@end

@implementation NewLocalFileViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"New File", @"New File");
	
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

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
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

	cell._field.secureTextEntry = NO;
	cell._field.clearsOnBeginEditing = NO;
	cell._field.text=@"";
	
    switch(indexPath.row){
		case ROW_FILENAME:{
			cell._field.placeholder = NSLocalizedString(@"File Name", @"File Name");
			break;
		}
		case ROW_PASSWORD_1:{
			cell._field.placeholder = NSLocalizedString(@"Password", @"Password");
			cell._field.secureTextEntry = YES;
			cell._field.clearsOnBeginEditing = YES;
			break;
		}
		case ROW_PASSWORD_2:{
			cell._field.placeholder = NSLocalizedString(@"Retype Password", @"Retype Password");
			cell._field.secureTextEntry = YES;
			cell._field.clearsOnBeginEditing = YES;
			break;
		}
		//case ROW_VERSION:{
		//	cell.label.text = NSLocalizedString(@"Kdb Version", @"Kdb Version");
		//	break;
		//}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

-(IBAction)cancelClicked:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewCancel" object:self];
}

-(IBAction)doneClicked:(id)sender{
	TextFieldCell * filename = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	TextFieldCell * password1 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	TextFieldCell * password2 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];	
	
	
	if([password1._field.text length]==0){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Password cannot be empty", @"Password cannot be empty") delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];	
		[alert show];
		[alert release];		
		return;	
	}
	
	if(![password1._field.text isEqualToString:password2._field.text]){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Passwords don't match", @"Passwords don't match") delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];	
		[alert show];
		[alert release];
	}else{
		NSString * name = [FileManager getFullFileName:[filename._field.text stringByAppendingPathExtension:@"kdb"]];
		if([[NSFileManager defaultManager] fileExistsAtPath:name]){
			UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
															message:NSLocalizedString(@"File already exsits. Do you want to overwrite it?", @"File already exists, overwrite?") delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
												  otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];	
			[alert show];
			[alert release];			
		}else{
			[self newKDB3File:[filename._field.text stringByAppendingPathExtension:@"kdb"] withPassword:password1._field.text];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex==1){
		TextFieldCell * filename = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		TextFieldCell * password1 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		[self newKDB3File:[filename._field.text stringByAppendingPathExtension:@"kdb"] withPassword:password1._field.text];		
	}
}

-(void)newKDB3File:(NSString *)filename withPassword:(NSString *)password{
	@try{
		[FileManager newKdb3File:filename withPassword:password];
	}@catch(NSException * exception){
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Error creating new file", @"Error creating new file") delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewOK" object:self];	
}

@end
