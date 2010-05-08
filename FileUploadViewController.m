//
//  FileUploadViewController.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/21/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "FileUploadViewController.h"
#import "MyHTTPConnection.h"
#import "MyKeePassAppDelegate.h"
#import "localhostAddresses.h"
#import "FileManager.h"

@interface FileUploadViewController (PrivateMethods)
-(void)startServer;
@end

@implementation FileUploadViewController
@synthesize _httpServer;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Upload File", @"Upload File");
	
	UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done") 
															 style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];
	
	self._httpServer = nil;
	_httpServer = [[HTTPServer alloc] init];
	[_httpServer setType:@"_http._tcp."];
	[_httpServer setConnectionClass:[MyHTTPConnection class]];
	[_httpServer setDocumentRoot:[NSURL fileURLWithPath:[FileManager dataDir]]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];	
	[self startServer];	
}

- (void)startServer{
	NSError *error;	
#if TARGET_IPHONE_SIMULATOR		
	[_httpServer setPort:8080];
#else
	[_httpServer setPort:80];
#endif
	if(![_httpServer start:&error]){
		UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		cell.textLabel.text = NSLocalizedString(@"Error starting web server", @"Error web server");
	}		
	[self displayInfoUpdate:nil];
}


- (void)displayInfoUpdate:(NSNotification *) notification{
	NSDictionary * addresses = nil;
	
	if(notification){
		addresses = [[notification object] copy];
	}
	
	if(addresses == nil){
		return;
	}
	
	NSString *info;
	UInt16 port = [_httpServer port];
	
	NSString *localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP){
		localIP = [addresses objectForKey:@"en1"];
	}
		
	if (!localIP)
		info = @"No WiFi Connection";
	else
		info = [NSString stringWithFormat:@"http://%@:%d", localIP, port];

	UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	cell.textLabel.text = info;
}

- (void)dealloc {
	[_httpServer release];
    [super dealloc];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;	
	
	if(indexPath.row==0){
		cell.textLabel.font = [UIFont systemFontOfSize:13];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.textColor = [UIColor darkGrayColor];
		cell.textLabel.text = NSLocalizedString(@"Use the address below to import/export KDB files", @"import/export");
	}else{
		cell.textLabel.font = [UIFont systemFontOfSize:15];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor =[UIColor blueColor];
		cell.textLabel.text = NSLocalizedString(@"Initializing...", @"Initializing");
	}
	
    return cell;
}

-(IBAction)doneClicked:(id)sender{
	[_httpServer stop];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissModalViewOK" object:self];	
}

@end

