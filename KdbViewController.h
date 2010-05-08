//
//  KdbViewController.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/6/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KdbLib.h>

@interface KdbViewController : UIViewController<UITabBarControllerDelegate, UIAlertViewDelegate> {
	UITabBarController * _tabBarController;
	id<KdbGroup> _group;
}

@property(nonatomic, retain) UITabBarController * _tabBarController;
@property(nonatomic, readonly) id<KdbGroup> _group;

-(id)initWithGroup:(id<KdbGroup>)group;

@end
