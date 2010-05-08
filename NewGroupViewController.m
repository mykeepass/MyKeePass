//
//  NewGroupViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/14/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "NewGroupViewController.h"
#import "TextFieldCell.h"
#import "TKTextViewCell.h"
#import "MyKeePassAppDelegate.h"

@implementation NewGroupViewController
@synthesize _parent;

- (void)dealloc {
	[_parent release];
    [super dealloc];
}

-(void)viewDidLoad{
	[super viewDidLoad];	
	UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") 
															   style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
	
	self.navigationItem.title = NSLocalizedString(@"Add Group", @"Add Group");
	
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
    [super didReceiveMemoryWarning];
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"NewGroupCell";
    
	TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TextFieldCell alloc] initWithIdentifier:CellIdentifier] autorelease];
	}
    
	cell._field.secureTextEntry = NO;
	cell._field.text = @"";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell._field.placeholder = NSLocalizedString(@"Group Name", @"Group Name");
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return NSLocalizedString(@"Group Name", @"Group Name");
}

-(IBAction)cancelClicked:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewCancel" object:self];	
}

-(IBAction)doneClicked:(id)sender{
	FileManager * fm = [MyKeePassAppDelegate delegate]._fileManager;
	
	if([fm getKDBVersion]==KDB_VERSION1){
		TextFieldCell * cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];		
		if([cell._field.text isEqualToString:@"Backup"]){
			UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
															message:NSLocalizedString(@"Group name is reserved", @"Group name is reserved") delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
												  otherButtonTitles:nil];	
			[alert show];
			[alert release];			
			return;
		}
		Kdb3Group * group =  [[Kdb3Group alloc]init];		
		group._title = cell._field.text;
		
		NSDate * now = [NSDate date];
		[group setExpiry:nil];
		[group setLastMod:now];
		[group setLastAccess:now];
		[group setCreation:now];
		
		[_parent addSubGroup:group];			
		[group release];
		fm._dirty = YES;
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewDone" object:self];
}
@end

