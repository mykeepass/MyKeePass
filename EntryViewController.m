//
//  EntryViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/7/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "EntryViewController.h"
#import "MultiLineTableViewCellStyle2.h"
#import "MyKeePassAppDelegate.h"
#import "EditNodeViewController.h"
#import "TKTextViewCell.h"

#define USERNAME_ROW 0
#define PASSWORD_ROW 1
#define WEBSITE_ROW 2
#define STANDARD_ROW_SIZE 3

@interface EntryViewController (PrivateMethods)
-(BOOL)isValidURL:(NSString *) url;
-(NSURL *)getURL:(NSString *)url;
@end


@implementation EntryViewController
@synthesize _entry;
@synthesize _passwordDisclosureView;

-(id)initWithEntry:(id<KdbEntry>)entry{
	if(self = [super initWithStyle:UITableViewStyleGrouped]){
		_entry = [entry retain];
		self.navigationItem.title = [_entry getEntryName];
		_passwordShown = NO;
		_passwordDisclosureView = [[PasswordDisclosureView alloc]init];
		[_passwordDisclosureView setAddButtonTarget:self selector:@selector(viewPasswordClicked:)];
	}
	return self;
}

- (void)dealloc {
	[_entry release];
	[_passwordDisclosureView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];

	if([[MyKeePassAppDelegate delegate] isEditable]){
		UIBarButtonItem * edit = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];		
		self.navigationItem.rightBarButtonItem = edit;
	}
}

-(IBAction)editClicked:(id)sender {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewDone:) name:@"DismissModalViewDone" object:nil];		
	EditNodeViewController *  editNodeViewController = [[EditNodeViewController alloc]initWithStyle:UITableViewStyleGrouped];				
	editNodeViewController._entry = self._entry;	
	UINavigationController *  navigationController = [[UINavigationController alloc]initWithRootViewController:editNodeViewController];
	[self presentModalViewController:navigationController animated:YES];
	[navigationController release];
	[editNodeViewController release];	
}

-(void)dismissModalViewCancel:(NSNotification *)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)dismissModalViewDone:(NSNotification *)notification{	
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[self dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0)
		return 3 + [_entry getNumberOfCustomAttributes];
	else
		return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([indexPath section]==0){	
		static NSString *CellIdentifier = @"EntryCell";
		
		MultiLineTableViewCellStyle2 *cell = (MultiLineTableViewCellStyle2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[MultiLineTableViewCellStyle2 alloc] init:CellIdentifier] autorelease];
		}		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell._trueValue = nil;
		if(indexPath.row<3){ //Standard attributes
			switch (indexPath.row) {
				case USERNAME_ROW:{
					cell.textLabel.text = NSLocalizedString(@"username", @"username");
					cell.detailTextLabel.text = [_entry getUserName];
					break;
				}
				case PASSWORD_ROW:{
					cell.textLabel.text = NSLocalizedString(@"password", @"password");	
					if(!_passwordShown)
						cell.detailTextLabel.text = @"••••••••";
					else
						cell.detailTextLabel.text = [_entry getPassword];	
					cell._trueValue = [_entry getPassword];
					if(!cell._trueValue) cell._trueValue=@"";
					break;
				}
				case WEBSITE_ROW:{
					cell.textLabel.text = NSLocalizedString(@"website", @"website");
					cell.detailTextLabel.text = [_entry getURL];
					break;
				}
			}
		}else{	//custom attributes
			NSUInteger idx = indexPath.row-STANDARD_ROW_SIZE;
			NSString * label = [_entry getCustomAttributeName:idx];
			NSString * value = [_entry getCustomAttributeValue:idx];
			cell.textLabel.text = label;
			cell.detailTextLabel.text = value;		
		}
		
		return cell;
	}else{ //the comment
		static NSString *CellIdentifier = @"CommentCell";
		
		TKTextViewCell *cell = (TKTextViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[TKTextViewCell alloc] initWithIdentifier:CellIdentifier] autorelease];
		}
		cell.textView.editable = NO;
		cell.textView.text = [_entry getComments];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		return cell;		
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(!self.editing&&[indexPath section]==0){		
		if([indexPath row]!=WEBSITE_ROW){
			UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
			[cell becomeFirstResponder];
			
			CGRect rect = { {100,20},{0, 0}};
			
			UIMenuController *theMenu = [UIMenuController sharedMenuController];
			[theMenu setTargetRect:rect inView:cell];
			[theMenu setMenuVisible:YES animated:YES];			
		}else{
			if(![self isValidURL:[_entry getURL]]){
				return;
			}
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil
															otherButtonTitles:
										  NSLocalizedString(@"Open URL", @"Open URL"), 
										  NSLocalizedString(@"Open URL w/ username", @"Open URL with username"), 
										  NSLocalizedString(@"Open URL w/ password", @"Open URL with password"),
										  nil];			
			[actionSheet showInView:[[MyKeePassAppDelegate delegate] window]]; // show from our table view (pops up in the middle of the table)
			[actionSheet release];
		}		
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch(buttonIndex){
		case 1:{
			UIPasteboard * gpBoard = [UIPasteboard generalPasteboard];
			gpBoard.string = [_entry getUserName];
			[[UIApplication sharedApplication] openURL:[self getURL:[_entry getURL]]];
			break;
		}
		case 2:{
			UIPasteboard * gpBoard = [UIPasteboard generalPasteboard];
			gpBoard.string = [_entry getPassword];
			[[UIApplication sharedApplication] openURL:[self getURL:[_entry getURL]]];
			break;
		}
		case 0:{
			[[UIApplication sharedApplication] openURL:[self getURL:[_entry getURL]]];
			break;
		}
	}	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section==0) 
		return nil;
	else {
		return NSLocalizedString(@"Comment", "Comment");
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if([indexPath section]==0){
		CGFloat rv = 0;
		
		if(indexPath.row<3){ //Standard attributes
			switch (indexPath.row) {
				case USERNAME_ROW:{
					rv = [MultiLineTableViewCellStyle2 heightOfCellWithLabel:NSLocalizedString(@"username", @"username") detail:[_entry getUserName]];
					break;
				}
				case PASSWORD_ROW:{
					if(!_passwordShown)
						rv = [MultiLineTableViewCellStyle2 heightOfCellWithLabel:NSLocalizedString(@"password", @"password") detail:@"••••••••"];
					else 
						rv = [MultiLineTableViewCellStyle2 heightOfCellWithLabel:NSLocalizedString(@"password", @"password") detail:[_entry getPassword]];
					break;
				}
				case WEBSITE_ROW:{
					rv = [MultiLineTableViewCellStyle2 heightOfCellWithLabel:NSLocalizedString(@"website", @"website") detail:[_entry getURL]];
					break;
				}
			}
		}else{	//custom attributes
			NSUInteger idx = indexPath.row-STANDARD_ROW_SIZE;	
			NSString * label = [_entry getCustomAttributeName:idx];
			NSString * value = [_entry getCustomAttributeValue:idx];
			rv = [MultiLineTableViewCellStyle2 heightOfCellWithLabel:label detail:value];
		}
		
		return MAX(rv+5, 44.0);
	}else{
		return 180;
	}
}

-(BOOL)isValidURL:(NSString *) url{
	NSString * trimmed  = [[_entry getURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	if(!trimmed||[trimmed length]==0) return NO;
	if([NSURL URLWithString:trimmed]) return YES;
	return NO;
}


//must call isValidURL first to check if url is valid
-(NSURL *)getURL:(NSString *)url{
	NSString * trimmed  = [[_entry getURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([trimmed rangeOfString:@"://"].location==NSNotFound){
		return [NSURL URLWithString:[@"http://" stringByAppendingString:trimmed]];
	}else{
		return [NSURL URLWithString:trimmed];
	}	
}

-(IBAction)viewPasswordClicked:(id)sender{
	_passwordShown = !_passwordShown;
	_passwordDisclosureView._button.selected = _passwordShown;
	[self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section==0) return _passwordDisclosureView;
	else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if(section==0) return 50;
	else return 35;
}

@end

