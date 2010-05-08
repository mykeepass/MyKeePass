//
//  About.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/26/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "AboutViewController.h"

#define EMAIL "mykeepass@gmail.com"

@implementation AboutViewController

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
    static NSString *CellIdentifier1 = @"Cell1";  

	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1] autorelease];
	}
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    if([indexPath section]==0){
		 		switch([indexPath row]){
			case 0:{
				cell.textLabel.text = NSLocalizedString(@"Version", @"Version");
				cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
				cell.accessoryType = UITableViewCellAccessoryNone;
				break;
			}
			case 1:{
				cell.textLabel.text = NSLocalizedString(@"Feedback", @"Feedback");
				cell.detailTextLabel.text = @EMAIL;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;			
			}
		}
	}
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"MyKeePass";
}

- (void)dealloc {
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if([indexPath row]==0) return;
	
	MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
	email.mailComposeDelegate = self;
	[email setToRecipients:[NSArray arrayWithObject:@EMAIL]];
	//email.navigationBar.barStyle = UIBarStyleBlack;	
	[self presentModalViewController:email animated:YES];
	[email release];	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
}

@end

