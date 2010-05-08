//
//  NewLocalFileViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/4/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewLocalFileViewController : UITableViewController <UIAlertViewDelegate> {

}
-(IBAction)cancelClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;
@end
