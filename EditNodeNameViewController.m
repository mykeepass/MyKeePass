//
//  EditGroupViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/15/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "EditNodeNameViewController.h"
#import "TextFieldCell.h"
#import "FileManager.h"
#import "MyKeePassAppDelegate.h"

@implementation EditNodeNameViewController
@synthesize _group;
@synthesize _entry;

- (void)dealloc {
	[_group release];
	[_entry release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[super viewDidLoad];	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") 
															   style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
	
	self.navigationItem.title = NSLocalizedString(@"Change Name", @"Change Name");
	
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];
	
	UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done") 
															 style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];		
	[cell._field becomeFirstResponder];
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
    return 1;
}

// Customize the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
	TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TextFieldCell alloc] initWithIdentifier:CellIdentifier] autorelease];
	}
    
	cell._field.secureTextEntry = NO;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell._field.text = _group?[_group getGroupName]:[_entry getEntryName];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return _group?NSLocalizedString(@"Group Name", @"Group Name"):NSLocalizedString(@"Entry Name", @"Entry Name");
}

-(IBAction)cancelClicked:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewCancel" object:self];	
}

-(IBAction)doneClicked:(id)sender{
	FileManager * fm = [MyKeePassAppDelegate delegate]._fileManager;
	TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if(_group){
		[_group setGroupName:cell._field.text];
		NSDate * now = [NSDate date];
		[_group setLastMod:now];
		[_group setLastAccess:now];		
	}else{
		[_entry setEntryName:cell._field.text];
		NSDate * now = [NSDate date];
		[_entry setLastMod:now];
		[_entry setLastAccess:now];	
		[[NSNotificationCenter defaultCenter] postNotificationName:@"EntryUpdated" object:nil];		
	}
	fm._dirty = YES;	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewDone" object:self];
}
@end

