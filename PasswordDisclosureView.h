//
//  PasswordDisclosureView.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/23/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasswordDisclosureView : UIView {
	UIButton * _button;
}

@property(nonatomic, retain) UIButton * _button;

-(id)setAddButtonTarget:(id)target selector:(SEL)selector;
@end
