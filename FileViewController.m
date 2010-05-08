//
//  FileViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "FileViewController.h"
#import "FileManager.h"
#import "TKLabelTextFieldCell.h"
#import "NewLocalFileViewController.h"
#import "NewRemoteFileViewController.h"
#import "MyKeePassAppDelegate.h"
#import "PasswordViewController.h"
#import "RenameFileViewController.h"
#import "RenameRemoteFileViewController.h"
#import "FileUploadViewController.h"

#define KDB1_SUFFIX ".kdb"
#define KDB2_SUFFIX ".kdbx"

#define NEW_FILE_BUTTON 0
#define IMPORT_DESKTOP_BUTTON 1
#define IMPORT_WEBSERVER_BUTTON 2

@interface FileViewController(PrivateMethods)
-(void)newFile;
-(void)downloadFile;
-(void)uploadFile;
@end


@implementation FileViewController
@synthesize _rowToDelete;


-(id)init{
	self = [super initWithStyle:UITableViewStylePlain];
	_files = [[NSMutableArray alloc]initWithCapacity:4];
	_remoteFiles = [[NSMutableArray alloc]initWithCapacity:4];
	[[MyKeePassAppDelegate delegate]._fileManager getKDBFiles:_files];
	[[MyKeePassAppDelegate delegate]._fileManager getRemoteFiles:_remoteFiles];
	return self;
}

- (void)dealloc {
	[_rowToDelete release];
	[_remoteFiles release];
	[_files release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_files count] + [_remoteFiles count];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row<[_files count]){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];		
		RenameFileViewController * renameFile = [[RenameFileViewController alloc]initWithStyle:UITableViewStyleGrouped];
		renameFile._filename = [_files objectAtIndex:indexPath.row];
		UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:renameFile];
		[self presentModalViewController:nav animated:YES];		
		[renameFile release];
		[nav release];
	}else{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];		
		RenameRemoteFileViewController * renameFile = [[RenameRemoteFileViewController alloc]initWithStyle:UITableViewStyleGrouped];
		renameFile._name = [_remoteFiles objectAtIndex:indexPath.row - [_files count]];
		renameFile._url = [[MyKeePassAppDelegate delegate]._fileManager getURLForRemoteFile:renameFile._name];
		UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:renameFile];
		[self presentModalViewController:nav animated:YES];		
		[renameFile release];
		[nav release];		
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FileViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	if(indexPath.row<[_files count]){ //local files
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		NSString * filename = [_files objectAtIndex:indexPath.row];
		UIImageView * iv = cell.imageView;
		if([filename hasSuffix:@KDB1_SUFFIX]){
			iv.image = [UIImage imageNamed:@"kdb.png"];
			filename = [filename substringToIndex:[filename length]-4];
			//cell.detailTextLabel.text = NSLocalizedString(@"KeePass 1.0",  @"KeePass 1.0");
		}else if ([filename hasSuffix:@KDB2_SUFFIX]){
			iv.image = [UIImage imageNamed:@"kdbx.png"];
			filename = [filename substringToIndex:[filename length]-5];
			//cell.detailTextLabel.text = NSLocalizedString(@"KeePass 2.0",  @"KeePass 2.0");
		}else{
			iv.image = [UIImage imageNamed:@"unknown.png"];
		}
		cell.textLabel.text = filename;
	}else { //remote files
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		NSString * filename = [_remoteFiles objectAtIndex:indexPath.row-[_files count]];
		UIImageView * iv = cell.imageView;
		iv.image = [UIImage imageNamed:@"http.png"];
		cell.textLabel.text = filename;
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		self._rowToDelete = indexPath;
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil 
														message:NSLocalizedString(@"Continue to delete the file?", @"Erase file confirmation") delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
											  otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];	
		[alert show];
		[alert release];
	}
}
		   
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(!self.editing){
		PasswordViewController * passwordView = nil;
		if(indexPath.row<[_files count]){
			passwordView = [[PasswordViewController alloc]initWithFileName:[_files objectAtIndex:indexPath.row] remote:NO];
		}else{
			passwordView = [[PasswordViewController alloc]initWithFileName:[_remoteFiles objectAtIndex:indexPath.row-[_files count]] remote:YES];
		}
		if(passwordView){ 
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];			
		}
		[self presentModalViewController:passwordView animated:YES];
		[passwordView release];
	}else{
		
	}
}

-(void)newFile{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];	
	NewLocalFileViewController * newLocalFile = [[NewLocalFileViewController alloc]initWithStyle:UITableViewStyleGrouped];
	UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:newLocalFile];
	[self presentModalViewController:nav animated:YES];
	[newLocalFile release];
	[nav release];
}

-(void)uploadFile{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];	
	FileUploadViewController * uploadFile = [[FileUploadViewController alloc]initWithStyle:UITableViewStyleGrouped];
	UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:uploadFile];
	[self presentModalViewController:nav animated:YES];
	[uploadFile release];
	[nav release];	
}

-(void)downloadFile{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewCancel:) name:@"DismissModalViewCancel" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewOK:) name:@"DismissModalViewOK" object:nil];	
	NewRemoteFileViewController * newRemoteFile = [[NewRemoteFileViewController alloc]initWithStyle:UITableViewStyleGrouped];
	UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:newRemoteFile];
	[self presentModalViewController:nav animated:YES];
	[newRemoteFile release];
	[nav release];
}

-(void)dismissModalViewCancel:(NSNotification *)notification{
	[self dismissModalViewControllerAnimated:YES];	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissModalViewOK:(NSNotification *)notification{
	[self dismissModalViewControllerAnimated:YES];
	
	//we need to display the groups
	if([[notification object] isKindOfClass:[PasswordViewController class]]){
		[[MyKeePassAppDelegate delegate] showKdb];
	}else if([[notification object] isKindOfClass:[NewRemoteFileViewController class]]){
		[[MyKeePassAppDelegate delegate]._fileManager getRemoteFiles:_remoteFiles];
		[self.tableView reloadData];
	}else if([[notification object] isKindOfClass:[NewLocalFileViewController class]]){
		[[MyKeePassAppDelegate delegate]._fileManager getKDBFiles:_files];
		[self.tableView reloadData];
	}else if([[notification object] isKindOfClass:[RenameFileViewController class]]){
		[[MyKeePassAppDelegate delegate]._fileManager getKDBFiles:_files];
		[self.tableView reloadData];	
	}else if([[notification object] isKindOfClass:[RenameRemoteFileViewController class]]){
		[[MyKeePassAppDelegate delegate]._fileManager getRemoteFiles:_remoteFiles];
		[self.tableView reloadData];		
	}else if([[notification object] isKindOfClass:[FileUploadViewController class]]){
		[[MyKeePassAppDelegate delegate]._fileManager getKDBFiles:_files];
		[self.tableView reloadData];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)addFile:(id)sender {
	UIActionSheet * as = [[UIActionSheet alloc]initWithTitle:nil delegate:self 
										   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil 
										   otherButtonTitles:NSLocalizedString(@"New KDB 1.0 File", @"New KDB 1.0 File"), 
															 NSLocalizedString(@"Upload From Desktop", @"Upload From Desktop"), 	
															 NSLocalizedString(@"Download From WWW", @"Download From WWW"), nil];
	[as showInView:[MyKeePassAppDelegate getWindow]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch(buttonIndex){
		case NEW_FILE_BUTTON:{
			[self newFile];
			break;
		}
		case IMPORT_DESKTOP_BUTTON:{
			[self uploadFile];
			break;
		}
		case IMPORT_WEBSERVER_BUTTON:{
			[self downloadFile];
			break;
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex==1&&_rowToDelete){
		if(_rowToDelete.row < [_files count]){
			[[MyKeePassAppDelegate delegate]._fileManager deleteLocalFile:[_files objectAtIndex:_rowToDelete.row]];
			[[MyKeePassAppDelegate delegate]._fileManager getKDBFiles:_files];
		}else{
			[[MyKeePassAppDelegate delegate]._fileManager deleteRemoteFile:[_remoteFiles objectAtIndex:_rowToDelete.row-[_files count]]];
			[[MyKeePassAppDelegate delegate]._fileManager getRemoteFiles:_remoteFiles];			
		}
		self._rowToDelete = nil;
		[self.tableView reloadData];
	}
}

@end

