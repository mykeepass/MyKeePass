//
//  PlainSectionHeader.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/7/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlainSectionHeader : UIView {
	UILabel * _label;
	UIButton * _button;
}

@property(nonatomic, retain) UILabel * _label;

-(id)setAddButtonTarget:(id)target selector:(SEL)selector;
- (id)initWithTitle:(NSString *) title;

@end
